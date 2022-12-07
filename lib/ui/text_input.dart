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
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late TextEditingController _controller;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    _focusNode.addListener(onFocusChange);
  }

  void onFocusChange() async {
    if (!_focusNode.hasFocus) {
      final bool? accepted = await widget.onSubmitted?.call(_controller.text);
      if (accepted == null) return;
      if (!accepted) {
        _controller.text = widget.initialValue ?? '';
      }
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
        DefaultSelectionStyle(
          cursorColor: Colors.black,
          selectionColor: Colors.black.withOpacity(0.1),
          child: SizedBox(
            width: widget.width,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              textAlign: widget.textAlign ?? TextAlign.start,
              inputFormatters: widget.inputFormatters,
              textInputAction: widget.textInputAction ?? TextInputAction.done,
              style: const TextStyle(height: 1.2, fontSize: 15)
                  .merge(widget.textStyle),
              decoration: InputDecoration(
                isDense: true,
                hintText: widget.hintText,
                hintTextDirection: TextDirection.ltr,
                hintStyle: const TextStyle(
                  height: 1.2,
                  color: Colors.grey,
                  fontSize: 14,
                ).merge(widget.hintStyle),
                contentPadding: widget.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.05),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade600,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
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
    _focusNode.dispose();
    super.dispose();
  }
}
