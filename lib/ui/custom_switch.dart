import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'gesture_detector_with_cursor.dart';

class CustomSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetectorWithCursor(
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            const SizedBox(height: 10),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: value,
                activeColor: Colors.black,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
