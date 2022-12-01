import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

class FlatColor with EquatableMixin {
  final String name;
  final Color background;
  final Color foreground;

  const FlatColor({
    required this.name,
    required this.background,
    required this.foreground,
  });

  @override
  List<Object?> get props => [name, background, foreground];

  FlatColor copyWith({
    String? name,
    Color? background,
    Color? foreground,
  }) {
    return FlatColor(
      name: name ?? this.name,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
    );
  }
}
