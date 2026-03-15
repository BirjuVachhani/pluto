import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import 'super_utils.dart';

/// Accepted image formats for drop operations.
const List<SimpleFileFormat> imageDropFormats = [
  Formats.png,
  Formats.jpeg,
  Formats.gif,
  Formats.webp,
  Formats.bmp,
  Formats.tiff,
  Formats.heic,
  Formats.heif,
];

/// Maximum file size allowed for upload (20MB).
const int defaultMaxFileSizeBytes = 20 * 1024 * 1024;

/// Callback type for media drop events that includes both files and directories.
typedef MediaDropCallback = void Function(List<XFile> files, List<String> directories);

/// A region that allows media to be dropped into it using drag and drop.
///
/// Supports both individual files and directories. Directories are detected
/// via file URI format on IO platforms (macOS, Windows, Linux).
class MediaDropRegion extends StatefulWidget {
  /// Creates a new [MediaDropRegion].
  const MediaDropRegion({
    this.child,
    this.dropZoneIndicator,
    this.disabled = false,
    required this.onDrop,
    super.key,
    this.onDropEnter,
    this.onDropLeave,
    this.onFileTooLarge,
    this.formats,
    this.builder,
    required this.maxFileSize,
    this.hitTestBehavior,
  }) : assert(child != null || builder != null);

  /// The child widget that is displayed in the drop region. The
  /// [dropZoneIndicator] will be rendered on top.
  final Widget? child;

  /// The widget that is displayed when media is being dropped into the region.
  final Widget? dropZoneIndicator;

  /// Whether the drop region is disabled.
  final bool disabled;

  /// The callback that is called when media is dropped into the region.
  ///
  /// Receives a list of [XFile] objects for individual files, and a list of
  /// directory paths for dropped directories. The caller is responsible for
  /// handling directories (e.g., recursively scanning for files).
  final MediaDropCallback onDrop;

  final ValueChanged<DropEvent>? onDropEnter;

  final ValueChanged<DropEvent>? onDropLeave;

  /// Called when a dropped file exceeds [maxFileSize].
  final FileTooLargeCallback? onFileTooLarge;

  final List<SimpleFileFormat>? formats;

  final int maxFileSize;

  final Widget Function(BuildContext context, bool isDropping, Widget? child)? builder;

  final HitTestBehavior? hitTestBehavior;

  @override
  State<MediaDropRegion> createState() => MediaDropRegionState();

  static MediaDropRegionState of(BuildContext context) => maybeOf(context)!;

  static MediaDropRegionState? maybeOf(BuildContext context) => context.findAncestorStateOfType<MediaDropRegionState>();
}

class MediaDropRegionState extends State<MediaDropRegion> {
  late List<SimpleFileFormat> formats =
      widget.formats ?? Formats.standardFormats.whereType<SimpleFileFormat>().toList();

  /// Whether media is currently being dropped into the region.
  bool isDropping = false;

  @override
  void didUpdateWidget(covariant MediaDropRegion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (listEquals(oldWidget.formats, widget.formats)) {
      formats = widget.formats ?? Formats.standardFormats.whereType<SimpleFileFormat>().toList();
    }
  }

  /// Marks the region as dropping media.
  void markDropping({required bool isDropping}) {
    this.isDropping = isDropping;
    if (mounted) setState(() {});
  }

  Future<void> onDrop(List<DropItem> items) async {
    final (:files, :directories) = await SuperUtils.onPerformDrop(
      items,
      formats: formats,
      maxFileSize: widget.maxFileSize,
      onFileTooLarge: widget.onFileTooLarge,
    );
    widget.onDrop(files, directories);
  }

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: formats,
      hitTestBehavior: widget.hitTestBehavior ?? HitTestBehavior.translucent,
      onDropOver: (event) {
        if (widget.disabled) return DropOperation.none;

        if (!SuperUtils.allowDropSession(event.session, formats)) {
          return DropOperation.none;
        }

        if (!isDropping) markDropping(isDropping: true);
        return DropOperation.copy;
      },
      onDropEnter: (event) {
        if (widget.disabled) return;

        if (!SuperUtils.allowDropSession(event.session, formats)) {
          return;
        }

        markDropping(isDropping: true);
        widget.onDropEnter?.call(event);
      },
      onDropLeave: (event) {
        if (widget.disabled) return;
        markDropping(isDropping: false);
        widget.onDropLeave?.call(event);
      },
      onDropEnded: (event) {
        if (widget.disabled) return;
        markDropping(isDropping: false);
      },
      onPerformDrop: (event) async => widget.disabled ? null : onDrop(event.session.items),
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.builder?.call(context, isDropping, widget.child) ?? widget.child!,
          if (isDropping && widget.dropZoneIndicator != null)
            Positioned.fill(
              child: widget.dropZoneIndicator!,
            ),
        ],
      ),
    );
  }
}
