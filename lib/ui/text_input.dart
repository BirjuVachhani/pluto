import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FutureOr<bool?>? Function(String)? onSubmitted;
  final String? initialValue;
  final String? label;
  final double? width;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final TextAlign? textAlign;
  final EdgeInsets? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onFocusLost;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Color? fillColor;
  final bool showInitialBorder;

  const TextInput({
    super.key,
    this.width,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.initialValue,
    this.label,
    this.inputFormatters,
    this.hintText,
    this.textAlign,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.textInputAction,
    this.focusNode,
    this.onFocusLost,
    this.suffix,
    this.suffixIcon,
    this.fillColor,
    this.showInitialBorder = true,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late TextEditingController _controller;

  late FocusNode _focusNode;

  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    if (!_focusNode.hasFocus && !isSubmitted) {
      _submit();
      widget.onFocusLost?.call();
      isSubmitted = false;
    }
  }

  void _submit() async {
    isSubmitted = true;
    final bool? accepted = await widget.onSubmitted?.call(_controller.text);
    if (accepted == null) return;
    if (!accepted) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void didUpdateWidget(covariant TextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) _controller.dispose();
      _controller =
          widget.controller ?? TextEditingController(text: widget.initialValue);
    }
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) _focusNode.dispose();
      oldWidget.focusNode?.removeListener(onFocusChange);
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(onFocusChange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!),
          const SizedBox(height: 10),
        ],
        SizedBox(
          width: widget.width,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            textAlign: widget.textAlign ?? TextAlign.start,
            inputFormatters: widget.inputFormatters,
            textInputAction: widget.textInputAction ?? TextInputAction.done,
            style: const TextStyle(
                    height: 1.2, fontSize: 15, fontWeight: FontWeight.w300)
                .merge(widget.textStyle),
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hintText,
              suffix: widget.suffix,
              suffixIcon: widget.suffixIcon,
              hintTextDirection: TextDirection.ltr,
              hintStyle: const TextStyle(
                height: 1.2,
                color: Colors.grey,
                fontSize: 14,
              ).merge(widget.hintStyle),
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              filled: true,
              fillColor: widget.fillColor ?? Colors.grey.withOpacity(0.05),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.showInitialBorder
                      ? Colors.grey.withOpacity(0.15)
                      : Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.showInitialBorder
                      ? Colors.grey.withOpacity(0.15)
                      : Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }
}
