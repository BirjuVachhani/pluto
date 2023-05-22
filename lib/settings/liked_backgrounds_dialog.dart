import 'dart:developer';
import 'dart:math' hide log;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../home/background_store.dart';
import '../model/background_settings.dart';
import '../resources/colors.dart';
import '../utils/storage_manager.dart';
import '../utils/universal/universal.dart';

enum DownloadState {
  downloading,
  downloaded,
  failed;

  bool get isDownloading => this == DownloadState.downloading;

  bool get isDownloaded => this == DownloadState.downloaded;

  bool get isFailed => this == DownloadState.failed;
}

class LikedBackgroundsDialog extends StatefulWidget {
  final BackgroundStore store;

  const LikedBackgroundsDialog({super.key, required this.store});

  @override
  State<LikedBackgroundsDialog> createState() => _LikedBackgroundsDialogState();
}

class _LikedBackgroundsDialogState extends State<LikedBackgroundsDialog> {
  late final LocalStorageManager storage =
      GetIt.instance.get<LocalStorageManager>();

  Map<String, DownloadState> downloadingItems = {};

  @override
  Widget build(BuildContext context) {
    final entries = widget.store.likedBackgrounds.entries.toList();
    return Center(
      child: Container(
        width: min(1024, MediaQuery.of(context).size.width * 0.9),
        height: min(720, MediaQuery.of(context).size.height * 0.9),
        decoration: BoxDecoration(
          color: AppColors.settingsPanelBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Photos you've liked",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        if (entries.isNotEmpty)
                          Text(
                            '${entries.length} photos',
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 16,
                      iconSize: 18,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            if (entries.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 100,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "You haven't liked any photos yet. Photos you like will show up here.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    maxCrossAxisExtent: 300,
                    mainAxisExtent: 300 * 9 / 16,
                  ),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final background = entries[index];
                    return _Item(
                      key: ValueKey(background.key),
                      entry: background,
                      downloadState: downloadingItems[background.value.url],
                      onUnlike: () => onUnlikeImage(background),
                      onDownload: () => onDownloadImage(background),
                      onOpen: () => onOpenImage(background),
                      onRemoveDownloadState: () => setState(() {
                        downloadingItems.remove(background.value.url);
                      }),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> onUnlikeImage(MapEntry<String, LikedBackground> entry) async {
    widget.store.removeLikedPhoto(entry.key);
    if (mounted) setState(() {});
  }

  Future<void> onDownloadImage(
      MapEntry<String, LikedBackground> background) async {
    if (downloadingItems[background.value.url] == DownloadState.downloading) {
      return;
    }
    downloadingItems[background.value.url] = DownloadState.downloading;
    if (mounted) setState(() {});

    try {
      final result = await http.get(Uri.parse(background.value.url));
      if (result.statusCode != 200) {
        downloadingItems[background.value.url] = DownloadState.failed;
        if (mounted) setState(() {});
        return;
      }
      final Uint8List bytes = result.bodyBytes;

      final fileName =
          'background_${DateTime.now().millisecondsSinceEpoch ~/ 1000}.jpg';

      if (kIsWeb) {
        await downloadImage(bytes, fileName);
        downloadingItems[background.value.url] = DownloadState.downloaded;
        if (mounted) setState(() {});
        return;
      }

      /// Show native save file dialog on desktop.
      final String? path = await FilePicker.platform.saveFile(
        type: FileType.image,
        dialogTitle: 'Save Image',
        fileName: fileName,
      );
      if (path == null) {
        downloadingItems.remove(background.value.url);
        if (mounted) setState(() {});
        return;
      }
      await downloadImage(bytes, path);
      downloadingItems[background.value.url] = DownloadState.downloaded;
      if (mounted) setState(() {});
    } catch (error, stacktrace) {
      log(error.toString());
      log(stacktrace.toString());
      downloadingItems[background.value.url] = DownloadState.failed;
      if (mounted) setState(() {});
    }
  }

  void onOpenImage(MapEntry<String, LikedBackground> background) {
    widget.store.onOpenImage(background.value);
  }
}

class _Item extends StatefulWidget {
  final MapEntry<String, LikedBackground> entry;
  final VoidCallback onUnlike;
  final VoidCallback onDownload;
  final VoidCallback onOpen;
  final DownloadState? downloadState;
  final VoidCallback onRemoveDownloadState;

  const _Item({
    super.key,
    required this.entry,
    required this.onUnlike,
    required this.onDownload,
    required this.onOpen,
    required this.downloadState,
    required this.onRemoveDownloadState,
  });

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> {
  @override
  void didUpdateWidget(covariant _Item oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.downloadState != oldWidget.downloadState) {
      if (widget.downloadState == DownloadState.downloaded ||
          widget.downloadState == DownloadState.failed) {
        Future.delayed(const Duration(seconds: 2), () {
          widget.onRemoveDownloadState();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ItemOptionButton(
          onPressed: widget.onUnlike,
          tooltip: 'Unlike',
          color: Colors.red,
          icon: const Icon(Icons.favorite_rounded),
        ),
        const SizedBox(width: 14),
        _ItemOptionButton(
          onPressed: widget.onDownload,
          tooltip: 'Download',
          color: Theme.of(context).colorScheme.primary,
          icon: const Icon(Icons.download_rounded),
        ),
        const SizedBox(width: 14),
        _ItemOptionButton(
          onPressed: widget.onOpen,
          tooltip: 'Open Image',
          color: Colors.grey.shade300,
          icon: const Icon(Icons.open_in_new_rounded),
        ),
      ],
    );
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.dropdownOverlayColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Hoverable(
          key: ValueKey(widget.entry.key),
          builder: (context, hovering, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                child!,
                if (widget.downloadState == null)
                  AnimatedOpacity(
                    opacity: hovering &&
                            widget.downloadState != DownloadState.downloading
                        ? 1
                        : 0,
                    duration: Duration(milliseconds: hovering ? 250 : 0),
                    curve: Curves.easeInOut,
                    child: Container(
                      color: hovering
                          ? Colors.black.withOpacity(0.8)
                          : Colors.transparent,
                      child: Center(
                        child: options,
                      ),
                    ),
                  ),
                AnimatedPositioned(
                  left: 0,
                  right: 0,
                  bottom: widget.downloadState != null ? 0 : -32,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: _DownloadIndicator(
                    downloadState: widget.downloadState,
                  ),
                ),
              ],
            );
          },
          child: _NetworkImageWithStates(
            url: widget.entry.value.url,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _DownloadIndicator extends StatelessWidget {
  final DownloadState? downloadState;

  const _DownloadIndicator({this.downloadState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29,
      alignment: Alignment.centerLeft,
      color: Colors.black.withOpacity(0.95),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              getText(),
              style: TextStyle(
                color: getIconColor(context),
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          if (downloadState == DownloadState.downloading)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(getIconColor(context)),
              ),
            )
          else
            Icon(
              getIcon(),
              color: getIconColor(context),
              size: 16,
            ),
        ],
      ),
    );
  }

  String getText() {
    switch (downloadState) {
      case DownloadState.downloading:
        return 'Downloading...';
      case DownloadState.downloaded:
        return 'Downloaded';
      case DownloadState.failed:
        return 'Failed';
      default:
        return '';
    }
  }

  Color getIconColor(BuildContext context) {
    switch (downloadState) {
      case DownloadState.downloading:
        return Theme.of(context).colorScheme.primary;
      case DownloadState.downloaded:
        return Colors.greenAccent.shade700;
      case DownloadState.failed:
        return Colors.redAccent;
      default:
        return Colors.white;
    }
  }

  IconData getIcon() {
    switch (downloadState) {
      case DownloadState.downloading:
        return Icons.download_rounded;
      case DownloadState.downloaded:
        return Icons.check_rounded;
      case DownloadState.failed:
        return Icons.info_outline_rounded;
      default:
        return Icons.download_rounded;
    }
  }
}

class _ItemOptionButton extends StatelessWidget {
  final Widget icon;
  final Color color;
  final VoidCallback onPressed;
  final String? tooltip;

  const _ItemOptionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: color,
        size: 24,
      ),
      child: Material(
        type: MaterialType.circle,
        color: color.withOpacity(0.1),
        child: Tooltip(
          message: tooltip ?? '',
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            overlayColor: MaterialStateProperty.all(
              color.withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}

class _NetworkImageWithStates extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final double? opacity;
  final double scale;
  final double? width;
  final double? height;

  const _NetworkImageWithStates({
    // ignore: unused_element
    super.key,
    required this.url,
    this.fit,
    // ignore: unused_element
    this.alignment = Alignment.center,
    // ignore: unused_element
    this.opacity,
    // ignore: unused_element
    this.scale = 1,
    // ignore: unused_element
    this.width,
    // ignore: unused_element
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      alignment: alignment,
      scale: scale,
      width: width,
      height: height,
      loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) =>
          AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: loadingProgress == null
            ? SizedBox.expand(child: child)
            : Center(
                child: CustomPaint(
                  painter: CircularProgressPainter(
                    radius: 12,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : 0,
                  ),
                ),
              ),
      ),
      errorBuilder: (context, Object error, StackTrace? stackTrace) => Icon(
        Icons.broken_image_outlined,
        size: 48,
        color: Colors.grey.shade800,
      ),
    );
  }
}

/// A widget that shows a circular progress indicator with a given [value].
/// The [radius] is the radius of the circle.
/// The [value] is the progress value between 0 and 1.
class CircularProgressPainter extends CustomPainter {
  final double radius;
  final double value;
  final Color color;

  final Paint arcPaint;
  final Paint strokePaint;

  CircularProgressPainter({
    required this.radius,
    required this.value,
    this.color = Colors.white,
  })  : arcPaint = Paint()..color = color,
        strokePaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);

    final double angle = value * 360;
    final angleInRadians = angle * pi / 180;
    canvas.drawCircle(center, radius, Paint()..color = color.withOpacity(0.1));
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        height: (radius * 2),
        width: (radius * 2),
      ),
      -pi / 2,
      angleInRadians,
      true,
      arcPaint,
    );

    canvas.drawCircle(center, radius, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) =>
      oldDelegate.radius != radius ||
      oldDelegate.value != value ||
      oldDelegate.color != color ||
      oldDelegate.arcPaint != arcPaint ||
      oldDelegate.strokePaint != strokePaint;
}

class RotationAnglePainter extends CustomPainter {
  final double angle;
  final Color lineColor;
  final Color angleArcColor;
  final Paint linePaint = Paint();

  RotationAnglePainter({
    required this.angleArcColor,
    required this.lineColor,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2.0, size.height / 2.0);

    /// Draw the angle line.
    canvas.drawLine(
        center,
        center +
            Offset((size.width / 2.0) * cos(angle - pi / 2),
                (size.height / 2.0) * sin(angle - pi / 2)),
        linePaint
          ..color = lineColor
          ..strokeWidth = 1.5);

    /// Filled in angle gradient.
    if (angle * 180 / pi < 0) {
      canvas.drawArc(
          Rect.fromCenter(
              center: center, width: size.width, height: size.height),
          -pi / 2,
          pi,
          true,
          linePaint
            ..color = angleArcColor
            ..style = PaintingStyle.fill);

      canvas.drawArc(
          Rect.fromCenter(
              center: center, width: size.width, height: size.height),
          pi / 2,
          angle + pi,
          true,
          linePaint
            ..color = angleArcColor
            ..style = PaintingStyle.fill);
    } else {
      canvas.drawArc(
          Rect.fromCenter(
              center: center, width: size.width, height: size.height),
          -pi / 2,
          angle,
          true,
          linePaint
            ..color = angleArcColor
            ..style = PaintingStyle.fill);
    }

    /// Draw center dot
    canvas.drawCircle(
        center,
        3,
        linePaint
          ..color = lineColor
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
