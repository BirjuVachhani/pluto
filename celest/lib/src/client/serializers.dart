// ignore_for_file: type=lint, unused_local_variable, unnecessary_cast, unnecessary_import

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:celest/celest.dart';
import 'package:celest_core/src/exception/cloud_exception.dart';
import 'package:celest_core/src/exception/serialization_exception.dart';
import 'package:shared/src/unsplash_collection.dart' as _$unsplash_collection;
import 'package:unsplash_client/src/model/photo.dart' as _$photo;

void initSerializers() {
  Serializers.instance
      .put(Serializer.define<BadRequestException, Map<String, Object?>>(
    serialize: ($value) => {r'message': $value.message},
    deserialize: ($serialized) {
      return BadRequestException(($serialized[r'message'] as String));
    },
  ));
  Serializers.instance
      .put(Serializer.define<InternalServerError, Map<String, Object?>>(
    serialize: ($value) => {r'message': $value.message},
    deserialize: ($serialized) {
      return InternalServerError(($serialized[r'message'] as String));
    },
  ));
  Serializers.instance
      .put(Serializer.define<UnauthorizedException, Map<String, Object?>?>(
    serialize: ($value) => {r'message': $value.message},
    deserialize: ($serialized) {
      return UnauthorizedException(
          (($serialized?[r'message'] as String?)) ?? 'Unauthorized');
    },
  ));
  Serializers.instance
      .put(Serializer.define<SerializationException, Map<String, Object?>>(
    serialize: ($value) => {
      r'message': $value.message,
      r'offset': $value.offset,
      r'source': $value.source,
    },
    deserialize: ($serialized) {
      return SerializationException(($serialized[r'message'] as String));
    },
  ));
  Serializers.instance.put(
      Serializer.define<_$unsplash_collection.UnsplashPhotoOrientation, String>(
    serialize: ($value) => $value.name,
    deserialize: ($serialized) {
      return _$unsplash_collection.UnsplashPhotoOrientation.values
          .byName($serialized);
    },
  ));
  Serializers.instance.put(Serializer.define<
      _$unsplash_collection.UnsplashSource, Map<String, dynamic>>(
    serialize: ($value) => $value.toJson(),
    deserialize: ($serialized) {
      return _$unsplash_collection.UnsplashSource.fromJson($serialized);
    },
  ));
  Serializers.instance
      .put(Serializer.define<_$photo.Photo, Map<String, dynamic>>(
    serialize: ($value) => $value.toJson(),
    deserialize: ($serialized) {
      return _$photo.Photo.fromJson($serialized);
    },
  ));
}
