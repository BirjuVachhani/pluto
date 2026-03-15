import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:super_clipboard/super_clipboard.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:universal_io/io.dart';

import 'extensions.dart';
import 'memory_file.dart';

/// Callback invoked when a file exceeds the maximum allowed size.
typedef FileTooLargeCallback = void Function(FileTooLargeError error);

final class SuperUtils {
  static const name = 'SuperUtils';

  SuperUtils._();

  static final MimeTypeResolver _mimeTypeResolver = MimeTypeResolver()
    ..addExtension('yaml', 'application/yaml')
    ..addExtension('yml', 'application/yaml');

  /// Checks if the system supports clipboard operations.
  static bool doesSystemSupportClipboard() {
    return SystemClipboard.instance != null;
  }

  static Future<void> copyFileToClipboard(String path) async {
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) return;

    final DataWriterItem item = DataWriterItem();
    item.add(Formats.fileUri(Uri.parse('file://$path')));
    item.add(Formats.plainText(p.basename(path)));

    await clipboard.write([item]);
  }

  static Future<void> copyFileBytesToClipboard(String path, Uint8List bytes) async {
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) return;

    final format = getFormatForFilePath(path);
    if (format == null) return;

    final DataWriterItem item = DataWriterItem();
    item.add(format(bytes));

    await clipboard.write([item]);
  }

  static SimpleFileFormat? getFormatForFilePath(String path) {
    final extension = p.extension(path).substring(1);
    return switch (extension) {
      'png' => Formats.png,
      'jpg' || 'jpeg' => Formats.jpeg,
      'gif' => Formats.gif,
      'webp' => Formats.webp,
      'bmp' => Formats.bmp,
      'tiff' => Formats.tiff,
      'heic' => Formats.heic,
      'heif' => Formats.heif,
      'ico' => Formats.ico,
      'pdf' => Formats.pdf,
      'svg' => Formats.svg,
      'csv' => Formats.csv,
      'md' => Formats.md,
      'txt' => Formats.plainTextFile,
      'json' => Formats.json,
      'zip' => Formats.zip,
      'tar' => Formats.tar,
      'html' => Formats.htmlFile,
      _ => Formats.plainTextFile,
    };
  }

  /// Takes the image data from the clipboard and uploads it.
  ///
  /// Returns a [MediaSelectionEvent] that represents the result of the media
  /// selection operation.
  /// Returns files and directory paths.
  static Future<({List<XFile> files, List<String> directories})> onPasteFromClipboard({
    int? maxFiles,
    VoidCallback? onPreSelection,
    VoidCallback? onPostSelection,
    required List<SimpleFileFormat>? formats,
    required int maxFileSize,
    FileTooLargeCallback? onFileTooLarge,
  }) async {
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) return (files: <XFile>[], directories: <String>[]);
    final ClipboardReader reader = await clipboard.read();

    return onPasteFromReader(
      reader,
      maxFiles: maxFiles,
      onPreSelection: onPreSelection,
      onPostSelection: onPostSelection,
      formats: formats,
      maxFileSize: maxFileSize,
      onFileTooLarge: onFileTooLarge,
    );
  }

  /// Takes the image data from the clipboard and uploads it.
  ///
  /// Returns a [MediaSelectionEvent] that represents the result of the media
  /// selection operation.
  /// Returns files and directory paths.
  static Future<({List<XFile> files, List<String> directories})> onPasteFromReader(
    ClipboardReader reader, {
    int? maxFiles,
    VoidCallback? onPreSelection,
    VoidCallback? onPostSelection,
    required List<SimpleFileFormat>? formats,
    Future<XFile?> Function(ClipboardDataReader reader)? onCustomRead,
    required int maxFileSize,
    FileTooLargeCallback? onFileTooLarge,
  }) async {
    // If no formats are provided, use the standard formats.
    formats ??= Formats.standardFormats.whereType<SimpleFileFormat>().toList();

    try {
      onPreSelection?.call();

      final List<XFile> files = <XFile>[];
      final List<String> directories = <String>[];

      if (reader.items.isEmpty) {
        throw Exception('No media found in your clipboard');
      }

      int counter = 0;
      for (final ClipboardDataReader item in reader.items) {
        if (maxFiles != null && counter++ >= maxFiles) break;

        bool found = false;
        if (item.canProvide(Formats.fileUri)) {
          // a file was copied. we can paste it.
          final uri = await item.readValue(Formats.fileUri);
          if (uri != null) {
            final file = File.fromUri(uri);
            if (await FileSystemEntity.isDirectory(file.path)) {
              directories.add(file.path);
              found = true;
              continue;
            } else {
              final xFile = await file.toMemoryXFile();
              files.add(xFile);
              found = true;
              continue;
            }
          }
        }
        if (!found) {
          for (final format in formats) {
            if (!item.canProvide(format)) continue;
            try {
              final XFile? file = await _readAsFile(item, format, maxFileSize);
              if (file != null) files.add(file);
              found = true;
              break;
            } on FileTooLargeError catch (error) {
              log('$error', name: name, error: error);
              onFileTooLarge?.call(error);
            } catch (error, stackTrace) {
              log('Error reading clipboard item with format $format', name: name, error: error, stackTrace: stackTrace);
            }
          }
        }

        if (found) continue;

        if (onCustomRead != null) {
          final file = await onCustomRead(item);
          if (file != null) {
            files.add(file);
            continue;
          }
        }
      }

      return (files: files, directories: directories);
    } catch (error, stackTrace) {
      log('Error reading from clipboard', name: name, error: error, stackTrace: stackTrace);
      return (files: <XFile>[], directories: <String>[]);
    } finally {
      onPostSelection?.call();
    }
  }

  /// Uploads the dropped files and detects directories.
  ///
  /// Returns files and directory paths from the drop operation.
  /// Directories are detected via [Formats.fileUri] (same pattern as clipboard paste).
  static Future<({List<XFile> files, List<String> directories})> onPerformDrop(
    List<DropItem> dropItems, {
    VoidCallback? onPreSelection,
    VoidCallback? onPostSelection,
    required List<SimpleFileFormat> formats,
    required int maxFileSize,
    FileTooLargeCallback? onFileTooLarge,
  }) async {
    try {
      onPreSelection?.call();
      final List<XFile> files = <XFile>[];
      final List<String> directories = <String>[];

      for (final DropItem dropItem in dropItems) {
        final DataReader? reader = dropItem.dataReader;

        // Data reader is not available, skip this item.
        if (reader == null) continue;

        // Check for file URI format first (detects directories on IO platforms).
        // DataReader.getValue uses a callback pattern, not async/await directly.
        if (reader.canProvide(Formats.fileUri)) {
          final uri = await _readFileUri(reader);
          if (uri != null) {
            final file = File.fromUri(uri);
            if (await FileSystemEntity.isDirectory(file.path)) {
              // Validate path is not empty before adding
              if (file.path.isNotEmpty) {
                directories.add(file.path);
              }
              continue; // Directory found, move to next item
            } else if (await file.exists()) {
              // It's a file via URI - read it directly for better path preservation
              final xFile = await file.toMemoryXFile();
              files.add(xFile);
              continue; // File found via URI, move to next item
            }
          }
        }

        // Fallback: Try reading as file using the standard format-based approach
        try {
          final XFile? file = await _readAsFile(reader, null, maxFileSize);
          if (file != null) files.add(file);
        } on FileTooLargeError catch (error) {
          log('$error', name: name, error: error);
          onFileTooLarge?.call(error);
        }
      }

      return (files: files, directories: directories);
    } finally {
      onPostSelection?.call();
    }
  }

  /// Reads a file URI from a DataReader using the callback-based getValue API.
  ///
  /// Returns the URI if available, or null if not.
  static Future<Uri?> _readFileUri(DataReader reader) {
    final Completer<Uri?> completer = Completer<Uri?>();

    final progress = reader.getValue<Uri>(
      Formats.fileUri,
      (Uri? uri) {
        if (!completer.isCompleted) {
          completer.complete(uri);
        }
      },
      onError: (error) {
        log('Error reading file URI', name: name, error: error);
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      },
    );

    // If progress is null, the format is not available - complete immediately
    if (progress == null) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    }

    return completer.future;
  }

  static bool allowDropSession(
    DropSession session,
    List<DataFormat> formats, {
    int? maxFiles,
  }) {
    if (maxFiles != null && session.items.length > maxFiles) return false;

    final DropItem item = session.items.first;
    for (final DataFormat format in formats) {
      if (item.canProvide(format)) return true;
    }

    // This drop region only supports copy operation.
    return session.allowedOperations.contains(DropOperation.copy);
  }

  /// `extensionFromMime` returns 'jpe' instead of
  /// 'jpeg' on .jpeg files because jpe comes first in the list of jpeg mime
  /// types.
  /// There is no way to manually traverse the list of mime types.
  static String getEffectiveExtensionFromMime(String mimeType) {
    final extension = extensionFromMime(mimeType);
    if (extension == 'jpe') {
      return 'jpeg';
    }
    return extension ?? '';
  }

  static String? lookupMimeType(String path, {List<int>? headerBytes}) =>
      _mimeTypeResolver.lookup(path, headerBytes: headerBytes);

  static String? lookupMimeTypeFrom(String path, {List<int>? fileBytes}) =>
      _mimeTypeResolver.lookup(path, headerBytes: fileBytes?.sublist(0, defaultMagicNumbersMaxLength));

  /// Retrieves the file from a dropped or pasted item. This is used to get the
  /// media file from the clipboard or drag-and-drop operations, which are not
  /// directly supported by the image picker plugin.
  static Future<XFile?> _readAsFile(
    DataReader reader, [
    FileFormat? format,
    int? maxFileSize,
  ]) {
    final Completer<XFile?> completer = Completer<XFile?>();
    reader.getFile(format, (DataReaderFile file) async {
      try {
        if (file.fileSize != null && maxFileSize != null && file.fileSize! > maxFileSize) {
          throw FileTooLargeError(
            filename: p.basename(file.fileName ?? 'unknown'),
            fileSize: file.fileSize!,
            filePath: file.fileName,
          );
        }
        final MemoryXFile? xFile = await file.toMemoryXFile(format);

        if (xFile == null) return completer.complete(null);

        completer.complete(xFile);
      } catch (error, stacktrace) {
        completer.completeError(error, stacktrace);
      }
    });

    return completer.future;
  }
}

/// Error thrown when a file exceeds the maximum allowed size.
final class FileTooLargeError extends Error {
  final int fileSize;
  final String filename;
  final String? filePath;

  FileTooLargeError({required this.fileSize, required this.filename, required this.filePath});

  @override
  String toString() {
    return 'FileTooLargeError: The file "$filename"${filePath != null ? ' at path "$filePath"' : ''} exceeds the maximum allowed size. File size: ${formatFileSize(fileSize)}.';
  }
}

/// Formats a byte count into a human-readable string (e.g. "1.50 MB").
String formatFileSize(int? bytes, {int decimals = 2}) {
  if (bytes == null) return '';
  if (bytes == 0) return '0 B';
  const k = 1024;
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  final i = (math.log(bytes) / math.log(k)).floor();
  return '${(bytes / math.pow(k, i)).toStringAsFixed(decimals)} ${sizes[i]}';
}
