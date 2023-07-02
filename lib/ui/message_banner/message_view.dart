import 'package:flutter/material.dart';

enum MessageType { info, warning, success, error, neutral }

extension MessageTypeExt on MessageType {
  Color get color {
    switch (this) {
      case MessageType.info:
        return Colors.blue;
      case MessageType.warning:
        return Colors.orange.shade800;
      case MessageType.success:
        return Colors.greenAccent.shade700;
      case MessageType.error:
        return Colors.red;
      case MessageType.neutral:
        return Colors.black;
    }
  }

  IconData get icon {
    switch (this) {
      case MessageType.info:
        return Icons.info_outlined;
      case MessageType.warning:
        return Icons.warning_amber_outlined;
      case MessageType.success:
        return Icons.done;
      case MessageType.error:
        return Icons.error_outline;
      case MessageType.neutral:
        return Icons.notifications;
    }
  }
}

enum MessageBannerStyle { transparent, semiTransparent, solid }

/// Actual UI widget for [MessageBanner].
class MessageBannerView extends StatelessWidget {
  final String message;
  final EdgeInsets padding;
  final MessageType type;
  final MessageBannerStyle style;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final double? iconSize;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool showIcon;
  final BorderRadius? borderRadius;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? iconOverride;

  const MessageBannerView({
    super.key,
    required this.message,
    required this.type,
    this.dismissible = false,
    this.onDismiss,
    this.iconSize,
    this.style = MessageBannerStyle.semiTransparent,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.textStyle,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.showIcon = true,
    this.borderRadius,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.iconOverride,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        borderRadius: borderRadius ?? BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (showIcon) ...[
            if (iconOverride != null)
              IconTheme(
                data: Theme.of(context).iconTheme.copyWith(
                      color: getContentColor(),
                      size: iconSize ?? 18,
                    ),
                child: iconOverride!,
              )
            else
              Icon(
                type.icon,
                color: getContentColor(),
                size: iconSize ?? 18,
              ),
            const SizedBox(width: 10),
          ],
          if (dismissible)
            Expanded(
              child: Text(
                message,
                maxLines: maxLines,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: getContentColor(),
                      height: 1,
                      fontSize: 13,
                    )
                    .merge(textStyle),
              ),
            ),
          if (!dismissible)
            Flexible(
              child: Text(
                message,
                maxLines: maxLines,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: getContentColor(),
                      height: 1,
                      fontSize: 13,
                    )
                    .merge(textStyle),
              ),
            ),
          if (dismissible) ...{
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onDismiss,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: getContentColor(),
                  ),
                ),
              ),
            ),
          },
        ],
      ),
    );
  }

  Color? getBackgroundColor() {
    switch (style) {
      case MessageBannerStyle.transparent:
        return null;
      case MessageBannerStyle.semiTransparent:
        return type.color.withOpacity(0.1);
      case MessageBannerStyle.solid:
        return type.color;
    }
  }

  Color getContentColor() {
    switch (style) {
      case MessageBannerStyle.transparent:
      case MessageBannerStyle.semiTransparent:
        return type.color;
      case MessageBannerStyle.solid:
        return Colors.white;
    }
  }
}
