import 'dart:async';

import 'package:flutter/material.dart';

import 'message_view.dart';

enum MessageBannerAnimationStyle { topToBottom, bottomToTop }

/// This can be used to show different type of message banners in the UI.
/// Use controller to show/hide messages.
///
/// if [animationBuilder] is provided then it will be used instead of default
/// sliding down animation.
///
/// [defaultAnimationStyle] defines whether to slide banner from up to down or
/// down to up. Note that this does not change banners position, it merely
/// affects the default translation animation used to show/hide banner.
///
/// Animations can be turned off when initializing controller.
///
/// e.g. MessageBannerController(animate: false)
///
/// Note: This view does not control its position in the UI and relies on the
/// user to manage it.
/// Example:
///       Stack(
///         children: [
///           Container(
///             child: // Your UI.
///           ),
///           Positioned(
///             bottom: 8,
///             left: 0,
///             right: 0,
///             child: MessageBanner(controller: messageBannerController),
///           ),
///         ],
///       );
/// Here, [Positioned] determines where the banner will be shown.
class MessageBanner extends StatefulWidget {
  final MessageBannerController controller;
  final ValueWidgetBuilder<double>? animationBuilder;
  final MessageBannerStyle bannerStyle;
  final MessageBannerAnimationStyle defaultAnimationStyle;
  final bool dismissible;
  final double? iconSize;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool showIcon;
  final BorderRadius? borderRadius;
  final CrossAxisAlignment crossAxisAlignment;

  const MessageBanner({
    super.key,
    required this.controller,
    this.animationBuilder,
    this.dismissible = false,
    this.iconSize,
    this.bannerStyle = MessageBannerStyle.semiTransparent,
    this.defaultAnimationStyle = MessageBannerAnimationStyle.bottomToTop,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.textStyle,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.showIcon = true,
    this.borderRadius,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  State<MessageBanner> createState() => _MessageBannerState();
}

class _MessageBannerState extends State<MessageBanner> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onStateChanged);
  }

  @override
  void didUpdateWidget(covariant MessageBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(onStateChanged);
      widget.controller.addListener(onStateChanged);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.animate) {
      return Visibility(
        visible: !widget.controller.hidden,
        child: MessageBannerView(
          message: widget.controller.message,
          type: widget.controller.type,
          style: widget.bannerStyle,
          dismissible: widget.dismissible,
          iconSize: widget.iconSize,
          padding: widget.padding,
          textStyle: widget.textStyle,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
          showIcon: widget.showIcon,
          borderRadius: widget.borderRadius,
          crossAxisAlignment: widget.crossAxisAlignment,
          onDismiss: () => widget.controller.dismiss(),
          iconOverride: widget.controller.icon,
        ),
      );
    }
    final animationDirection =
        widget.defaultAnimationStyle == MessageBannerAnimationStyle.topToBottom
            ? -1
            : 1;
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      tween: widget.controller.showing
          ? Tween<double>(begin: 0, end: 1)
          : Tween<double>(begin: 1, end: 0),
      onEnd: widget.controller._onAnimationEnd,
      builder: (_, value, child) =>
          widget.animationBuilder?.call(context, value, child) ??
          Transform.translate(
            offset: Offset(0, (1 - value) * 20 * animationDirection),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          ),
      child: !widget.controller.hidden
          ? MessageBannerView(
              message: widget.controller.message,
              type: widget.controller.type,
              style: widget.bannerStyle,
              dismissible: widget.dismissible,
              iconSize: widget.iconSize,
              padding: widget.padding,
              onDismiss: () => widget.controller.dismiss(),
              textStyle: widget.textStyle,
              maxLines: widget.maxLines,
              overflow: widget.overflow,
              showIcon: widget.showIcon,
              crossAxisAlignment: widget.crossAxisAlignment,
              borderRadius: widget.borderRadius,
              iconOverride: widget.controller.icon,
            )
          : const SizedBox.shrink(),
    );
  }

  void onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(onStateChanged);
    super.dispose();
  }
}

enum MessageBannerPosition { top, bottom }

/// Wraps sub widget tree into a stack and shows banner on top of it.
/// [position] defines where the banner will be shown.
/// Either [child] or [builder] must be provided.
class MessageBannerStack extends StatefulWidget {
  final WidgetBuilder? builder;
  final Widget? child;
  final MessageBannerController? controller;
  final ValueWidgetBuilder<double>? animationBuilder;
  final MessageBannerStyle bannerStyle;
  final double horizontalSpacing;
  final double verticalSpacing;
  final MessageBannerPosition position;
  final bool dismissible;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool showIcon;
  final BorderRadius? borderRadius;
  final CrossAxisAlignment crossAxisAlignment;

  const MessageBannerStack({
    super.key,
    this.child,
    this.builder,
    this.controller,
    this.animationBuilder,
    this.bannerStyle = MessageBannerStyle.solid,
    this.position = MessageBannerPosition.bottom,
    this.horizontalSpacing = 16,
    this.verticalSpacing = 16,
    this.dismissible = false,
    this.textStyle,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.showIcon = true,
    this.borderRadius,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : assert(child != null || builder != null,
            'Either child or builder cannot be null.');

  @override
  State<MessageBannerStack> createState() => _MessageBannerStackState();
}

class _MessageBannerStackState extends State<MessageBannerStack> {
  late MessageBannerController controller;

  bool shouldDisposeController = false;

  @override
  void initState() {
    super.initState();
    shouldDisposeController = widget.controller == null;
    controller = widget.controller ?? MessageBannerController();
  }

  @override
  void didUpdateWidget(covariant MessageBannerStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      shouldDisposeController = widget.controller == null;
      controller = widget.controller ?? MessageBannerController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Builder(
            builder: (context) =>
                widget.child ?? widget.builder!.call(context)),
        Positioned(
          left: widget.horizontalSpacing,
          right: widget.horizontalSpacing,
          top: widget.position == MessageBannerPosition.top
              ? widget.verticalSpacing
              : null,
          bottom: widget.position == MessageBannerPosition.bottom
              ? widget.verticalSpacing
              : null,
          child: MessageBanner(
            controller: controller,
            animationBuilder: widget.animationBuilder,
            bannerStyle: widget.bannerStyle,
            dismissible: widget.dismissible,
            textStyle: widget.textStyle,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
            showIcon: widget.showIcon,
            borderRadius: widget.borderRadius,
            crossAxisAlignment: widget.crossAxisAlignment,
            defaultAnimationStyle: widget.position == MessageBannerPosition.top
                ? MessageBannerAnimationStyle.topToBottom
                : MessageBannerAnimationStyle.bottomToTop,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (shouldDisposeController) {
      controller.dispose();
    }
    super.dispose();
  }
}

class MessageBannerController extends ChangeNotifier {
  String _message = '';

  String get message => _message;

  MessageType _type = MessageType.info;

  MessageType get type => _type;

  final bool _animate;

  bool get animate => _animate;

  bool _autoHide = false;

  bool get autoHide => _autoHide;

  Duration _duration = const Duration(seconds: 3);

  Duration get duration => _duration;

  bool _showing = false;

  bool get showing => _showing;

  bool _hidden = true;

  bool get hidden => _hidden;

  /// Allows to control animation for rapid changes.
  int _timeStamp = -1;

  Widget? _icon;

  Widget? get icon => _icon;

  MessageBannerController({bool animate = true}) : _animate = animate;

  /// Allows to access controller child widget tree.
  static MessageBannerController? of(BuildContext context) {
    return context
        .findAncestorStateOfType<_MessageBannerStackState>()
        ?.controller;
  }

  FutureOr<void> showMessage(
    String message,
    MessageType type, {
    bool autoHide = true,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
  }) async {
    if (showing) {
      // Dismiss already showing banner.
      dismiss();
      await Future.delayed(const Duration(milliseconds: 250));
    }
    _icon = icon;
    final triggered = DateTime.now().millisecondsSinceEpoch;
    _timeStamp = triggered;
    _message = message;
    _type = type;
    _autoHide = autoHide;
    _duration = duration;
    _hidden = false;
    _showing = true;
    notifyListeners();

    // check for auto hide,
    if (autoHide) {
      await Future.delayed(duration);
      if (triggered != _timeStamp) return;
      _showing = false;
      if (!animate) {
        _hidden = true;
      }
      notifyListeners();
    }
  }

  void hide() {
    if (!_showing && _hidden) return;
    _showing = false;
    if (!animate) {
      _hidden = true;
    }
    notifyListeners();
  }

  FutureOr<void> showInfo(
    String message, {
    bool autoHide = true,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
  }) =>
      showMessage(
        message,
        MessageType.info,
        autoHide: autoHide,
        duration: duration,
        icon: icon,
      );

  FutureOr<void> showWarning(
    String message, {
    bool autoHide = true,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
  }) =>
      showMessage(
        message,
        MessageType.warning,
        autoHide: autoHide,
        duration: duration,
        icon: icon,
      );

  FutureOr<void> showSuccess(
    String message, {
    bool autoHide = true,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
  }) =>
      showMessage(
        message,
        MessageType.success,
        autoHide: autoHide,
        duration: duration,
        icon: icon,
      );

  FutureOr<void> showError(
    String message, {
    bool autoHide = true,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
  }) =>
      showMessage(
        message,
        MessageType.error,
        autoHide: autoHide,
        duration: duration,
        icon: icon,
      );

  FutureOr<void> showNeutral(
    String message, {
    bool autoHide = true,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
  }) =>
      showMessage(
        message,
        MessageType.neutral,
        autoHide: autoHide,
        duration: duration,
        icon: icon,
      );

  void _onAnimationEnd() {
    if (!showing) {
      _hidden = true;
      _timeStamp = -1;
      notifyListeners();
    }
  }

  void dismiss() {
    _showing = false;
    if (!animate) {
      _hidden = true;
    }
    notifyListeners();
  }
}
