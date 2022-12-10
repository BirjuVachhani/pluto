import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../ui/texture_painter.dart';
import '../utils/utils.dart';
import 'background_model.dart';

class HomeBackground extends StatefulWidget {
  const HomeBackground({super.key});

  @override
  State<HomeBackground> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground> {
  late final BackgroundModelBase model = context.read<BackgroundModelBase>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model.windowSize = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    // This enables a fade in transition on opening a new tab.
    // return TweenAnimationBuilder<double>(
    //   key: const Key('HomeBackground'),
    //   duration: const Duration(milliseconds: 0),
    //   curve: Interval(0.1, 1,curve: Curves.easeOut),
    //   tween: Tween<double>(begin: 0, end: 1),
    //   builder: (context, value, child) {
    //     return Opacity(opacity: value, child: child);
    //   },
    // );
    return Consumer<BackgroundModelBase>(
      builder: (context, model, child) {
        if (!model.initialized) return const SizedBox.shrink();

        final imageBytes = model.getImage();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            gradient: getBackground(model),
          ),
          foregroundDecoration: BoxDecoration(
            color: (model.invert ? Colors.white : AppColors.tint)
                .withOpacity(model.tint / 100),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (model.mode.isImage && imageBytes != null)
                Positioned.fill(
                  child: ImageBackgroundView(
                    imageBytes: imageBytes,
                    showLoadingBackground: model.showLoadingBackground,
                    greyScale: model.greyScale,
                  ),
                ),
              if (model.texture)
                Positioned.fill(
                  child: CustomPaint(
                    painter: TexturePainter(
                      color: model.getForegroundColor().withOpacity(0.4),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Color? getBackgroundColor(BackgroundModelBase model) {
    if (!model.mode.isColor) return null;
    return model.color.background;
  }

  LinearGradient? getBackground(BackgroundModelBase model) {
    if (model.mode.isImage) return null;
    final gradient = model.gradient;

    final colors = model.mode.isGradient
        ? gradient.colors
        : [model.color.background, model.color.background];

    return LinearGradient(
      colors: colors,
      begin: gradient.begin,
      end: gradient.end,
      stops: model.mode.isGradient ? gradient.stops : null,
    );
  }
}

class ImageBackgroundView extends StatefulWidget {
  final Uint8List imageBytes;
  final bool showLoadingBackground;
  final bool greyScale;

  const ImageBackgroundView({
    super.key,
    required this.imageBytes,
    this.showLoadingBackground = false,
    this.greyScale = false,
  });

  @override
  State<ImageBackgroundView> createState() => _ImageBackgroundViewState();
}

class _ImageBackgroundViewState extends State<ImageBackgroundView> {
  late Uint8List imageBytes1;
  late Uint8List imageBytes2;

  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    super.initState();
    imageBytes1 = imageBytes2 = widget.imageBytes;
  }

  @override
  void didUpdateWidget(covariant ImageBackgroundView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentBytes =
        crossFadeState == CrossFadeState.showFirst ? imageBytes1 : imageBytes2;
    if (currentBytes != widget.imageBytes) {
      if (crossFadeState == CrossFadeState.showFirst) {
        imageBytes2 = widget.imageBytes;
      } else {
        imageBytes1 = widget.imageBytes;
      }
      crossFadeState = crossFadeState == CrossFadeState.showFirst
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      key: const ValueKey('Background Image'),
      crossFadeState: crossFadeState,
      reverseDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 500),
      layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
        return SizedBox(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                key: bottomChildKey,
                child: bottomChild,
              ),
              Positioned(
                key: topChildKey,
                child: topChild,
              ),
            ],
          ),
        );
      },
      firstChild: ImageChild(
        key: const ValueKey('imageBytes1'),
        imageBytes: imageBytes1,
        greyScale: widget.greyScale,
        showLoadingBackground: widget.showLoadingBackground,
        showing: crossFadeState == CrossFadeState.showFirst,
      ),
      secondChild: ImageChild(
        key: const ValueKey('imageBytes2'),
        imageBytes: imageBytes2,
        greyScale: widget.greyScale,
        showLoadingBackground: widget.showLoadingBackground,
        showing: crossFadeState == CrossFadeState.showSecond,
      ),
    );
  }
}

class ImageChild extends StatefulWidget {
  final Uint8List imageBytes;
  final bool showLoadingBackground;
  final bool showing;
  final bool greyScale;

  const ImageChild({
    super.key,
    required this.imageBytes,
    this.showLoadingBackground = false,
    required this.showing,
    this.greyScale = false,
  });

  @override
  State<ImageChild> createState() => _ImageChildState();
}

class _ImageChildState extends State<ImageChild> {
  bool showGreyScale = false;

  @override
  void initState() {
    super.initState();
    showGreyScale = widget.showLoadingBackground && widget.showing;
  }

  @override
  void didUpdateWidget(covariant ImageChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageBytes != widget.imageBytes) {
      showGreyScale = widget.showLoadingBackground && widget.showing;
    }
    if (oldWidget.showLoadingBackground && !widget.showLoadingBackground) {
      Future.delayed(const Duration(milliseconds: 500), () {
        showGreyScale = false;
        if (mounted) setState(() {});
      });
    }
    if (widget.showLoadingBackground && widget.showing) showGreyScale = true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: greyscale(),
            child: Image.memory(
              widget.imageBytes,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity:
                (showGreyScale && widget.showing) || widget.greyScale ? 0 : 1,
            child: Image.memory(
              widget.imageBytes,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
