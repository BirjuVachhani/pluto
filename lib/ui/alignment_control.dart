import 'package:flutter/material.dart';

import '../model/widget_settings.dart';
import 'custom_dropdown.dart';

class AlignmentControl extends StatelessWidget {
  final String? label;
  final AlignmentC alignment;
  final ValueChanged<AlignmentC> onChanged;

  const AlignmentControl({
    super.key,
    this.label,
    required this.alignment,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          Text(label!),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            // AlignmentUI(
            //   size: 100,
            //   alignment: alignment,
            //   onChanged: onChanged,
            // ),
            // const SizedBox(width: 16),
            Expanded(
              child: CustomDropdown<AlignmentC>(
                key: ValueKey(alignment),
                // label: 'Alignment',
                value: alignment,
                isExpanded: true,
                items: AlignmentC.values,
                itemBuilder: (context, alignment) => Text(alignment.label),
                onSelected: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AlignmentUI extends StatefulWidget {
  final double size;
  final AlignmentC alignment;
  final ValueChanged<AlignmentC> onChanged;

  const AlignmentUI({
    super.key,
    required this.alignment,
    required this.onChanged,
    required this.size,
  });

  @override
  State<AlignmentUI> createState() => _AlignmentUIState();
}

class _AlignmentUIState extends State<AlignmentUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.grey.shade100,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final centerBoxSize = constraints.maxWidth / 3;
          return Center(
            child: Container(
              width: centerBoxSize,
              height: centerBoxSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
