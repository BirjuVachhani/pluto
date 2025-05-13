import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../ui/texture_painter.dart';
import '../utils/custom_observer.dart';
import '../utils/utils.dart';
import 'background_store.dart';

class HomeBackground extends StatefulWidget {
  const HomeBackground({super.key});

  @override
  State<HomeBackground> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground> {
  late final BackgroundStore store = context.read<BackgroundStore>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    store.windowSize = MediaQuery.of(context).size;
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
    return CustomObserver(
      name: 'HomeBackground',
      builder: (context) {
        if (!store.initialized) return const SizedBox.shrink();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            gradient: backgroundGradient,
          ),
          // foregroundDecoration: BoxDecoration(
          //   color: (store.invert ? Colors.white : AppColors.tint)
          //       .withValues(alpha:store.tint / 100),
          // ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: CustomObserver(
                  name: 'HomeBackgroundImage',
                  builder: (context) {
                    final Uint8List? imageBytes = store.currentImage?.bytes;

                    if (!store.isImageMode || imageBytes == null) {
                      return const SizedBox.shrink();
                    }

                    return ImageBackgroundView(
                      imageBytes: imageBytes,
                      showLoadingBackground: store.showLoadingBackground,
                      greyScale: store.greyScale,
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: CustomObserver(
                  name: 'HomeBackgroundTint',
                  key: const ValueKey('HomeBackgroundTint'),
                  builder: (context) {
                    return AnimatedContainer(
                      key: const ValueKey('HomeBackgroundTint-Container'),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        color: (store.invert ? Colors.white : AppColors.tint)
                            .withValues(alpha: store.tint / 100),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: CustomObserver(
                  name: 'HomeBackgroundTexture',
                  builder: (context) {
                    if (!store.texture) return const SizedBox.shrink();
                    return CustomPaint(
                      painter: TexturePainter(
                        color: store.foregroundColor.withValues(alpha: 0.4),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  LinearGradient? get backgroundGradient {
    if (store.isImageMode) return null;
    final gradient = store.gradient;

    final colors = store.isGradientMode
        ? gradient.colors
        : [store.color.background, store.color.background];

    return LinearGradient(
      colors: colors,
      begin: gradient.begin,
      end: gradient.end,
      stops: store.isGradientMode ? gradient.stops : null,
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
