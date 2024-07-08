import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/background_settings.dart';
import '../ui/gesture_detector_with_cursor.dart';
import '../utils/custom_observer.dart';
import 'background_store.dart';
import 'home_store.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BackgroundStore store = context.read<BackgroundStore>();
    return CustomObserver(
      name: 'BottomBar',
      builder: (context) {
        if (!store.initialized) return const SizedBox.shrink();
        return LinearHorizon(
          enabled: store.mode == BackgroundMode.image,
          color: store.invert ? Colors.white : Colors.black,
          childBuilder: (context, hovering) {
            return CustomObserver(
              name: 'Bottom Bar Left',
              builder: (context) => Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        style: DefaultTextStyle.of(context).style.copyWith(
                              color: hovering
                                  ? store.foregroundColor.withOpacity(0.8)
                                  : store.foregroundColor.withOpacity(0.2),
                              decorationColor: hovering
                                  ? store.foregroundColor.withOpacity(0.8)
                                  : store.foregroundColor.withOpacity(0.2),
                              fontWeight: FontWeight.w300,
                            ),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            if (store.currentImage
                                case UnsplashPhoto background) ...[
                              const Text('Photo by '),
                              GestureDetectorWithCursor(
                                onTap: () => onUnsplashUserLinkTap(background),
                                child: Text(
                                  background.photo.user.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    decoration: hovering
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                              const Text(' on '),
                              GestureDetectorWithCursor(
                                onTap: () =>
                                    launchUrlString('https://unsplash.com'),
                                child: Text(
                                  'Unsplash',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    decoration: hovering
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 132,
                              height: 2,
                              child: Visibility(
                                visible: store.isLoadingImage,
                                child: Transform.translate(
                                  offset: Offset.zero,
                                  // offset: const Offset(72, -120),
                                  child: Transform.rotate(
                                    // angle: pi / 2,
                                    angle: 0,
                                    child: LinearProgressIndicator(
                                      color: store.foregroundColor,
                                      minHeight: 4,
                                      borderRadius: BorderRadius.circular(100),
                                      backgroundColor: store.foregroundColor
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            const ChangeBackgroundButton(),
                            const SizedBox(width: 16),
                            const SettingsButton(),
                            const LikeBackgroundButton(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void onUnsplashUserLinkTap(UnsplashPhoto background) {
    Uri uri = background.photo.user.links.html;
    uri = uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        // This is required by Unsplash's API guidelines.
        'utm_source': 'pluto',
        'utm_medium': 'referral',
      },
    );
    launchUrlString(uri.toString());
  }
}

class RadialHorizon extends StatefulWidget {
  final Widget child;
  final Color? color;

  const RadialHorizon({
    super.key,
    required this.child,
    this.color,
  });

  @override
  State<RadialHorizon> createState() => _RadialHorizonState();
}

class _RadialHorizonState extends State<RadialHorizon> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: hovering ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              child: Container(
                height: 150,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (widget.color ?? Colors.white).withOpacity(1),
                      (widget.color ?? Colors.white).withOpacity(0.7),
                      Colors.transparent,
                    ],
                    stops: const [0.25, 0.3, 0.35],
                    center: const Alignment(0, 20.2),
                    focalRadius: 1,
                    radius: 30,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MouseRegion(
              onEnter: (_) => setState(() => hovering = true),
              onExit: (_) => setState(() => hovering = false),
              child: ColoredBox(
                color: Colors.transparent,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LinearHorizon extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final Widget Function(BuildContext context, bool hovering)? childBuilder;
  final bool enabled;

  const LinearHorizon({
    super.key,
    this.child,
    this.childBuilder,
    this.color,
    this.enabled = true,
  }) : assert(child != null || childBuilder != null,
            'child or childBuilder must be provided');

  @override
  Widget build(BuildContext context) {
    final Color color = this.color ?? Colors.black;
    return Hoverable(
      builder: (context, hovering, child) {
        return SizedBox(
          height: 60,
          child: Stack(
            children: [
              if (enabled)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 60,
                  child: AnimatedOpacity(
                    opacity: hovering ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            // (color ?? Colors.black).withOpacity(1),
                            // (color ?? Colors.black).withOpacity(0.7),
                            color.withOpacity(0.8),
                            color.withOpacity(0.4),
                            color.withOpacity(0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          // stops: const [0, 0.4, 1],
                        ),
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ColoredBox(
                  color: Colors.transparent,
                  child: childBuilder?.call(context, hovering) ?? child,
                ),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}

class SettingsButton extends StatefulWidget {
  const SettingsButton({super.key});

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BackgroundStore store = context.read<BackgroundStore>();
    return CustomObserver(
      name: 'SettingsButton',
      builder: (context) {
        if (!store.initialized) return const SizedBox.shrink();

        final color = store.foregroundColor;
        return GestureDetectorWithCursor(
          onTap: () {
            context.read<HomeStore>().showPanel();
          },
          onEnter: (_) => controller.forward(),
          onExit: (_) => controller.reverse(),
          tooltip: 'Settings',
          child: AnimatedBuilder(
            animation: CurvedAnimation(
              parent: controller,
              curve: Curves.fastOutSlowIn,
            ),
            builder: (context, child) {
              return Transform.rotate(
                angle: controller.value * pi / pi,
                child: Icon(
                  Icons.settings,
                  color: color.withOpacity(max(0.2, controller.value)),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ChangeBackgroundButton extends StatefulWidget {
  const ChangeBackgroundButton({super.key});

  @override
  State<ChangeBackgroundButton> createState() => _ChangeBackgroundButtonState();
}

class _ChangeBackgroundButtonState extends State<ChangeBackgroundButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BackgroundStore store = context.read<BackgroundStore>();
    return CustomObserver(
      name: 'ChangeBackgroundButton',
      builder: (context) {
        if (!store.initialized) return const SizedBox.shrink();

        final color = store.foregroundColor;
        return GestureDetectorWithCursor(
          onTap: !store.isLoadingImage ? store.onChangeBackground : null,
          onEnter: (_) => controller.forward(),
          onExit: (_) => controller.reverse(),
          tooltip: 'Change Background',
          child: AnimatedBuilder(
            animation: CurvedAnimation(
              parent: controller,
              curve: Curves.fastOutSlowIn,
            ),
            builder: (context, child) {
              return ImageIcon(
                AssetImage(store.isLoadingImage
                    ? 'assets/images/ic_hourglass.png'
                    : 'assets/images/ic_fan.png'),
                color: color.withOpacity(max(0.2, controller.value)),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class LikeBackgroundButton extends StatefulWidget {
  const LikeBackgroundButton({super.key});

  @override
  State<LikeBackgroundButton> createState() => _LikeBackgroundButtonState();
}

class _LikeBackgroundButtonState extends State<LikeBackgroundButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BackgroundStore store = context.read<BackgroundStore>();
    return CustomObserver(
      name: 'LikeBackgroundButton',
      builder: (context) {
        if (!store.initialized || !store.isImageMode) {
          return const SizedBox.shrink();
        }
        if (store.imageSource == ImageSource.userLikes &&
            store.likedBackgrounds.length <= 1) {
          return const SizedBox.shrink();
        }

        final color = store.foregroundColor;
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetectorWithCursor(
            onTap: !store.showLoadingBackground
                ? () => store.onToggleLike(!store.isLiked)
                : null,
            onEnter: (_) => controller.forward(),
            onExit: (_) => controller.reverse(),
            tooltip: store.isLiked ? 'Liked' : 'Like',
            child: AnimatedBuilder(
              animation: CurvedAnimation(
                parent: controller,
                curve: Curves.fastOutSlowIn,
              ),
              builder: (context, child) {
                return Icon(
                  store.isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: color.withOpacity(max(0.2, controller.value)),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
