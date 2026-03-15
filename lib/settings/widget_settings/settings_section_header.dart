import 'package:flutter/material.dart';

/// Section header used across widget settings views.
/// Muted uppercase label that visually groups related controls.
class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: Colors.white.withValues(alpha: 0.4),
      ),
    );
  }
}
