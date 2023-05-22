import 'dart:math';

import 'package:flutter/material.dart';

class ResizableTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? initialValue;
  final double initialHeight;
  final String? label;

  const ResizableTextInput({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.initialValue,
    this.label,
    this.initialHeight = 200,
  });

  @override
  State<ResizableTextInput> createState() => _ResizableTextInputState();
}

class _ResizableTextInputState extends State<ResizableTextInput> {
  late TextEditingController _controller;

  late FocusNode _focusNode;

  late double _height;

  double dragStartHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    _focusNode.addListener(onFocusChange);
    _height = dragStartHeight = widget.initialHeight;
  }

  void onFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.onSubmitted?.call(_controller.text);
    }
  }

  @override
  void didUpdateWidget(covariant ResizableTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) _controller.dispose();
      _controller =
          widget.controller ?? TextEditingController(text: widget.initialValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!),
          const SizedBox(height: 10),
        ],
        Stack(
          children: [
            SizedBox(
              height: _height,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                expands: true,
                maxLines: null,
                style:
                    const TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  filled: true,
                  isCollapsed: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.15),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -5,
              bottom: -5,
              child: GestureDetector(
                onHorizontalDragDown: (details) {
                  dragStartHeight = _height;
                },
                onHorizontalDragUpdate: (details) {
                  _height = dragStartHeight + details.localPosition.dy;
                  _height = max(_height, 50);
                  setState(() {});
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeUpDown,
                  child: SizedBox(
                    child: Transform.rotate(
                      angle: pi / 180 * -45,
                      child: Icon(
                        Icons.filter_list,
                        color: Colors.grey.withOpacity(0.3),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
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
