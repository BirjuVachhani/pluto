import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unsplash_collection.g.dart';

const String unsplashBaseUrl = 'https://source.unsplash.com';

enum UnsplashSourceType { random, collection, user, likes }

abstract class UnsplashSource with EquatableMixin {
  abstract final UnsplashSourceType type;
  final String name;

  const UnsplashSource({required this.name});

  String getPath();

  Map<String, dynamic> toJson();

  factory UnsplashSource.fromJson(Map<String, dynamic> json) {
    final type = json['type'] != null
        ? UnsplashSourceType.values.byName(json['type'])
        : UnsplashSourceType.random;
    switch (type) {
      case UnsplashSourceType.random:
        return UnsplashRandomSource.fromJson(json);
      case UnsplashSourceType.collection:
        return UnsplashCollectionSource.fromJson(json);
      case UnsplashSourceType.user:
        return UnsplashUserSource.fromJson(json);
      case UnsplashSourceType.likes:
        return UnsplashLikesSource.fromJson(json);
    }
  }
}

@JsonSerializable()
class UnsplashRandomSource extends UnsplashSource {
  @override
  String getPath() => '/random';

  @override
  final UnsplashSourceType type = UnsplashSourceType.random;

  const UnsplashRandomSource({super.name = 'Random'});

  factory UnsplashRandomSource.fromJson(Map<String, dynamic> json) =>
      _$UnsplashRandomSourceFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$UnsplashRandomSourceToJson(this)..['type'] = type.name;

  @override
  List<Object?> get props => [type, name];
}

abstract class UnsplashIdentifiableSource extends UnsplashSource {
  final String id;

  const UnsplashIdentifiableSource({required this.id, required super.name});
}

@JsonSerializable()
class UnsplashCollectionSource extends UnsplashIdentifiableSource {
  @override
  String getPath() => '/collection/$id';

  @override
  final UnsplashSourceType type = UnsplashSourceType.collection;

  const UnsplashCollectionSource({
    required super.id,
    required super.name,
  });

  factory UnsplashCollectionSource.fromJson(Map<String, dynamic> json) =>
      _$UnsplashCollectionSourceFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$UnsplashCollectionSourceToJson(this)..['type'] = type.name;

  @override
  List<Object?> get props => [type, id, name];
}

@JsonSerializable()
class UnsplashUserSource extends UnsplashIdentifiableSource {
  @override
  String getPath() => '/user/$id';

  @override
  final UnsplashSourceType type = UnsplashSourceType.user;

  const UnsplashUserSource({
    required super.id,
    required super.name,
  });

  factory UnsplashUserSource.fromJson(Map<String, dynamic> json) =>
      _$UnsplashUserSourceFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$UnsplashUserSourceToJson(this)..['type'] = type.name;

  @override
  List<Object?> get props => [type, id, name];
}

@JsonSerializable()
class UnsplashLikesSource extends UnsplashIdentifiableSource {
  @override
  String getPath() => '/user/$id/likes';

  @override
  final UnsplashSourceType type = UnsplashSourceType.likes;

  const UnsplashLikesSource({
    required super.id,
    required super.name,
  });

  factory UnsplashLikesSource.fromJson(Map<String, dynamic> json) =>
      _$UnsplashLikesSourceFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$UnsplashLikesSourceToJson(this)..['type'] = type.name;

  @override
  List<Object?> get props => [type, id, name];
}
