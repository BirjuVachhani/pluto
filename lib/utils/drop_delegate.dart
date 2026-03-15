import 'package:flutter/widgets.dart';
import 'package:super_clipboard/super_clipboard.dart';

/// Signature for building a custom drop overlay.
///
/// [isHovering] is `true` when the cursor is directly over the drop zone
/// (vs. merely dragging somewhere in the window).
///
/// [onDismiss] should be called to manually dismiss the overlay (e.g., via a
/// close button).
typedef DropOverlayBuilder =
    Widget Function(
      BuildContext context, {
      required bool isHovering,
      required VoidCallback onDismiss,
    });

/// Enables drag-and-drop file support for [ChatPromptInput].
///
/// This delegate is the single source of truth for all drop-related state.
/// It consolidates both window-level drag detection (via [dragNotifier]) and
/// zone-level hover state into one [ChangeNotifier].
///
/// Drop support also requires an [AttachmentDelegate] to be provided — the
/// file size limit for drops comes from [AttachmentDelegate.maxFileSize].
///
/// ## Wiring
///
/// The host provides a [ValueNotifier<bool>] that tracks whether something is
/// being dragged over the application window. This is typically set by a
/// root-level [DropRegion] wrapping the entire app:
///
/// ```dart
/// // At the app root:
/// final windowDragNotifier = ValueNotifier<bool>(false);
/// DropRegion(
///   formats: Formats.standardFormats,
///   onDropEnter: (_) => windowDragNotifier.value = true,
///   onDropLeave: (_) => windowDragNotifier.value = false,
///   onPerformDrop: (_) async => windowDragNotifier.value = false,
///   child: MyApp(),
/// )
///
/// // Deep in the tree:
/// ChatPromptInput(
///   dropDelegate: DropDelegate(dragNotifier: windowDragNotifier),
///   attachmentDelegate: myAttachmentDelegate,
/// )
/// ```
class DragAndDropDelegate extends ChangeNotifier {
  /// Host-owned notifier that signals whether something is being dragged
  /// over the application window.
  ///
  /// The host is responsible for setting this value based on platform-specific
  /// drag detection (e.g., a root-level [DropRegion]).
  final ValueNotifier<bool> dragNotifier;

  /// Accepted file formats for the drop region.
  ///
  /// When null, all [Formats.standardFormats] are accepted.
  final List<SimpleFileFormat>? formats;

  /// Custom overlay widget shown when files are being dragged over the input.
  ///
  /// When null, a generic semi-transparent overlay is rendered. Hosts can set
  /// this to provide a richer drop indicator (e.g., dotted border, blur, icons).
  ///
  /// The builder receives [isHovering] (cursor directly over the drop zone)
  /// and [onDismiss] (to manually close the overlay). Visibility animation
  /// is handled by the prompt input — the builder only defines the visual.
  DropOverlayBuilder? overlayBuilder;

  bool _isHoveringOverZone = false;

  DragAndDropDelegate({
    required this.dragNotifier,
    this.formats,
    this.overlayBuilder,
  }) {
    dragNotifier.addListener(notifyListeners);
  }

  /// Whether something is being dragged over the application window.
  bool get isDraggingOverWindow => dragNotifier.value;

  /// Whether the cursor is directly over the drop zone.
  bool get isHoveringOverZone => _isHoveringOverZone;

  /// Whether the drop overlay should be visible — either the user is dragging
  /// something over the window or hovering directly over the drop zone.
  bool get isActive => isDraggingOverWindow || isHoveringOverZone;

  set isHoveringOverZone(bool value) {
    if (_isHoveringOverZone == value) return;
    _isHoveringOverZone = value;
    notifyListeners();
  }

  /// Resets all drop state — both window-level drag and zone-level hover.
  void dismiss() {
    dragNotifier.value = false;
    _isHoveringOverZone = false;
    notifyListeners();
  }

  @override
  void dispose() {
    dragNotifier.removeListener(notifyListeners);
    super.dispose();
  }
}

/// Provides a [DragAndDropDelegate] to descendant widgets.
///
/// Wrap this around a subtree (typically near the root-level [DropRegion]) so
/// that [PromptInputWithBannerCombo] and other consumers can automatically
/// pick up the delegate without explicit parameter threading.
class DragAndDropScope extends InheritedWidget {
  final DragAndDropDelegate delegate;

  const DragAndDropScope({super.key, required this.delegate, required super.child});

  static DragAndDropDelegate? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DragAndDropScope>()?.delegate;
  }

  @override
  bool updateShouldNotify(DragAndDropScope oldWidget) => delegate != oldWidget.delegate;
}
