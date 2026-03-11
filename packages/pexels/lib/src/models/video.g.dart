// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
  id: (json['id'] as num).toInt(),
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  url: json['url'] as String,
  image: json['image'] as String,
  duration: (json['duration'] as num).toInt(),
  fullRes: json['full_res'],
  tags: json['tags'] as List<dynamic>? ?? [],
  user: VideoUser.fromJson(json['user'] as Map<String, dynamic>),
  videoFiles: (json['video_files'] as List<dynamic>)
      .map((e) => VideoFile.fromJson(e as Map<String, dynamic>))
      .toList(),
  videoPictures: (json['video_pictures'] as List<dynamic>)
      .map((e) => VideoPicture.fromJson(e as Map<String, dynamic>))
      .toList(),
);

VideoUser _$VideoUserFromJson(Map<String, dynamic> json) => VideoUser(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  url: json['url'] as String,
);

VideoFile _$VideoFileFromJson(Map<String, dynamic> json) => VideoFile(
  id: (json['id'] as num).toInt(),
  quality: json['quality'] as String,
  fileType: json['file_type'] as String,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  link: json['link'] as String,
  fps: (json['fps'] as num?)?.toDouble(),
);

VideoPicture _$VideoPictureFromJson(Map<String, dynamic> json) => VideoPicture(
  id: (json['id'] as num).toInt(),
  picture: json['picture'] as String,
  nr: (json['nr'] as num).toInt(),
);

VideoList _$VideoListFromJson(Map<String, dynamic> json) => VideoList(
  page: (json['page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  totalResults: (json['total_results'] as num).toInt(),
  nextPage: json['next_page'] as String?,
  prevPage: json['prev_page'] as String?,
  videos: (json['videos'] as List<dynamic>)
      .map((e) => Video.fromJson(e as Map<String, dynamic>))
      .toList(),
);
