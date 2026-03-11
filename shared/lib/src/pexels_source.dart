import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pexels_source.g.dart';

enum PexelsSourceType { random, search }

sealed class PexelsSource with EquatableMixin {
  final String name;
  abstract final PexelsSourceType type;

  const PexelsSource({required this.name});

  Map<String, dynamic> toJson();

  factory PexelsSource.fromJson(Map<String, dynamic> json) {
    final type = json['type'] != null
        ? PexelsSourceType.values.byName(json['type'])
        : PexelsSourceType.random;
    switch (type) {
      case PexelsSourceType.random:
        return PexelsRandomSource.fromJson(json);
      case PexelsSourceType.search:
        return PexelsSearchSource.fromJson(json);
    }
  }
}

@JsonSerializable()
class PexelsRandomSource extends PexelsSource {
  @override
  final PexelsSourceType type = PexelsSourceType.random;

  const PexelsRandomSource({super.name = 'Random'});

  factory PexelsRandomSource.fromJson(Map<String, dynamic> json) =>
      _$PexelsRandomSourceFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$PexelsRandomSourceToJson(this)..['type'] = type.name;

  @override
  List<Object?> get props => [type, name];
}

@JsonSerializable()
class PexelsSearchSource extends PexelsSource {
  final String query;

  @override
  final PexelsSourceType type = PexelsSourceType.search;

  const PexelsSearchSource({required super.name, required this.query});

  factory PexelsSearchSource.fromJson(Map<String, dynamic> json) =>
      _$PexelsSearchSourceFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$PexelsSearchSourceToJson(this)..['type'] = type.name;

  @override
  List<Object?> get props => [type, name, query];
}
