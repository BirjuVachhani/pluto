import 'dart:convert';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';

/// This is a fix for [XFile] on web for image cropping.
/// On web, when cropped image bytes are stored in an [XFile] object,
/// retrieving fails to decode the image for some reason. This implementation
/// overrides retrieval behavior to return the bytes directly.
class MemoryXFile extends XFile {
  final Uint8List bytes;

  /// TODO: This is a temp fix for issue: https://github.com/flutter/flutter/issues/102076
  /// Remove it when the issue is fixed.
  final String _fileName;

  final String _path;

  @override
  String get path => _path;

  @override
  String get name => _fileName;

  MemoryXFile(
    this.bytes, {
    String? mimeType,
    required String name,
    int? length,
    DateTime? lastModified,
    String? path,
  }) : _fileName = name,
       _path = path ?? name,
       super(
         path ?? name,
         bytes: bytes,
         mimeType: mimeType,
         name: name,
         length: length,
         lastModified: lastModified,
       );

  @override
  Future<Uint8List> readAsBytes() async => bytes;

  @override
  Future<String> readAsString({Encoding encoding = utf8}) => Future<String>.value(encoding.decode(bytes));

  @override
  Future<int> length() => Future<int>.value(bytes.length);
}
