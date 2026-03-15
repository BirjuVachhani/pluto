import 'package:flutter/material.dart';

import '../model/widget_settings.dart';
import '../resources/colors.dart';

/// A 3x3 visual grid for picking alignment. Each cell represents a
/// position (topLeft, center, bottomRight, etc.). The selected cell
/// is highlighted with the primary accent color. Spatial and instant
/// to understand — no dropdown scanning required.
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

  // Grid order: row-major, top-left to bottom-right.
  static const _grid = [
    [AlignmentC.topLeft, AlignmentC.topCenter, AlignmentC.topRight],
    [AlignmentC.centerLeft, AlignmentC.center, AlignmentC.centerRight],
    [AlignmentC.bottomLeft, AlignmentC.bottomCenter, AlignmentC.bottomRight],
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          Text(label!),
          const SizedBox(height: 10),
        ],
        Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: 1,
            child: AspectRatio(
              aspectRatio: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.borderColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: List.generate(3, (row) {
                    return Expanded(
                      child: Row(
                        children: List.generate(3, (col) {
                          final cell = _grid[row][col];
                          final selected = cell == alignment;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => onChanged(cell),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Tooltip(
                                  message: cell.label,
                                  waitDuration: const Duration(milliseconds: 400),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 120),
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: selected ? primary : Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Center(
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 120),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
