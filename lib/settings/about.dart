import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../resources/fonts.dart';
import '../ui/gesture_detector_with_cursor.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Center(
          child: PlutoLogo(size: 110, animate: true),
        ),
        const SizedBox(height: 16),
        Text(
          'Plut°'.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            letterSpacing: 10,
            height: 1,
            // fontWeight: FontWeight.bold,
            fontFamily: FontFamilies.systemUI,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'v${packageInfo.version}'.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2,
            fontFamily: FontFamilies.systemUI,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 48),
        Text(
          'Made with love ❤️ in',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 11,
            letterSpacing: 0.2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetectorWithCursor(
          onTap: () => launchUrl(Uri.parse('https://flutter.dev')),
          child: Container(
            padding: const EdgeInsets.only(right: 4),
            height: 24,
            child: const FlutterLogo(
              style: FlutterLogoStyle.horizontal,
              size: 72,
              textColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Developed by',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 11,
            letterSpacing: 0.2,
            color: Theme.of(context).colorScheme.primary,
            // color: Colors.white.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Birju Vachhani'.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              height: 1,
              fontSize: 10,
              // fontWeight: FontWeight.w400,
              fontFamily: FontFamilies.systemUI,
              letterSpacing: 4,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetectorWithCursor(
              onTap: () =>
                  launchUrl(Uri.parse('https://twitter.com/birjuvachhani')),
              child: SizedBox.square(
                dimension: 26,
                child: Image.asset('assets/images/ic_twitter.png'),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetectorWithCursor(
              onTap: () =>
                  launchUrl(Uri.parse('https://github.com/birjuvachhani')),
              child: SizedBox.square(
                dimension: 26,
                child: Image.asset(
                  'assets/images/ic_github.png',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 14),
            GestureDetectorWithCursor(
              onTap: () => launchUrl(Uri.parse('https://birju.dev')),
              child: SizedBox.square(
                dimension: 30,
                child: Image.asset(
                  'assets/images/ic_globe.png',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'Backgrounds by',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 11,
            letterSpacing: 0.2,
            color: Theme.of(context).colorScheme.primary,
            // color: Colors.white.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetectorWithCursor(
          onTap: () => launchUrl(Uri.parse('https://unsplash.com')),
          child: Image.asset(
            'assets/images/ic_unsplash.png',
            height: 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Weather & Geocoding API by',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 11,
            letterSpacing: 0.2,
            color: Theme.of(context).colorScheme.primary,
            // color: Colors.white.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetectorWithCursor(
          onTap: () => launchUrl(Uri.parse('https://open-meteo.com')),
          child: Image.asset(
            'assets/images/ic_open_meteo.png',
            height: 32,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class PlutoLogo extends StatefulWidget {
  final double size;
  final bool animate;

  const PlutoLogo({
    super.key,
    this.size = 120,
    this.animate = true,
  });

  @override
  State<PlutoLogo> createState() => _PlutoLogoState();
}

class _PlutoLogoState extends State<PlutoLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  );

  @override
  void initState() {
    super.initState();
    // _controller.repeat(
    //   period: const Duration(seconds: 10),
    // );
    if (!widget.animate) return;
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!widget.animate) return;
        _controller.reset();
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant PlutoLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.animate && widget.animate) {
      _controller.repeat();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/ic_pluto_logo_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * pi,
                child: child,
              );
            },
            child: SizedBox.square(
              dimension: widget.size * 0.7,
              child: Image.asset(
                'assets/images/ic_pluto_planet.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Shadow
          SizedBox.square(
            dimension: (widget.size * 0.7) + 1,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  radius: 0.75,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(1),
                  ],
                  stops: const [0.3, 0.5, 0.7, 1],
                  center: const Alignment(-0.4, -0.5),
                ),
              ),
            ),
          ),
          // SizedBox.square(
          //   dimension: size * 0.7,
          //   child: Image.asset(
          //     'assets/images/ic_pluto.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
