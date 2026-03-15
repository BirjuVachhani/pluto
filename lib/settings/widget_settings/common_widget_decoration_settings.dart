import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/background_store.dart';
import '../../home/widget_store.dart';
import '../../model/widget_settings.dart';
import '../../ui/custom_dropdown.dart';
import '../../ui/custom_slider.dart';
import '../../utils/custom_observer.dart';
import 'settings_section_header.dart';

/// A reusable settings section for the common widget decoration properties:
/// background type (none / color / glass / border), border radius,
/// padding, and margin.
class CommonWidgetDecorationSettings extends StatelessWidget {
  final CommonWidgetSettingsAccessor settings;

  const CommonWidgetDecorationSettings({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SettingsSectionHeader(title: 'Appearance'),
        const SizedBox(height: 12),
        LabeledObserver(
          label: 'Background',
          builder: (context) {
            return CustomDropdown<WidgetBackgroundType>(
              isExpanded: true,
              value: settings.decoration.type,
              items: WidgetBackgroundType.values,
              itemBuilder: (context, type) => Text(type.label),
              onSelected: (type) {
                settings.update(() {
                  settings.decoration = _buildDecoration(type, settings.decoration);
                });
              },
            );
          },
        ),
        CustomObserver(
          name: 'DecorationSubControls',
          builder: (context) {
            return switch (settings.decoration) {
              NoDecoration() => const SizedBox.shrink(),
              ColorDecoration d => _ColorDecorationControls(
                decoration: d,
                settings: settings,
              ),
              GlassDecoration d => _GlassDecorationControls(
                decoration: d,
                settings: settings,
              ),
              BorderDecoration d => _BorderDecorationControls(
                decoration: d,
                settings: settings,
              ),
            };
          },
        ),
        CustomObserver(
          name: 'BorderRadius',
          builder: (context) {
            if (settings.decoration is NoDecoration) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: LabeledObserver(
                label: 'Corner Radius',
                builder: (context) {
                  return CustomSlider(
                    min: 0,
                    max: 300,
                    valueLabel: '${settings.decoration.borderRadius.floor()} px',
                    value: settings.decoration.borderRadius,
                    onChanged: (value) {
                      settings.update(() {
                        settings.decoration = _copyWithBorderRadius(
                          settings.decoration,
                          value.floorToDouble(),
                        );
                      });
                    },
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        const SettingsSectionHeader(title: 'Spacing'),
        const SizedBox(height: 12),
        LabeledObserver(
          label: 'Padding',
          builder: (context) {
            return _LinkedSliderPair(
              horizontalValue: settings.horizontalPadding,
              verticalValue: settings.verticalPadding,
              max: 200,
              onHorizontalChanged: (v) => settings.update(
                () => settings.horizontalPadding = v.floorToDouble(),
              ),
              onVerticalChanged: (v) => settings.update(
                () => settings.verticalPadding = v.floorToDouble(),
              ),
              onBothChanged: (v) => settings.update(() {
                settings.horizontalPadding = v.floorToDouble();
                settings.verticalPadding = v.floorToDouble();
              }),
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Margin',
          builder: (context) {
            return _LinkedSliderPair(
              horizontalValue: settings.horizontalMargin,
              verticalValue: settings.verticalMargin,
              max: 200,
              onHorizontalChanged: (v) => settings.update(
                () => settings.horizontalMargin = v.floorToDouble(),
              ),
              onVerticalChanged: (v) => settings.update(
                () => settings.verticalMargin = v.floorToDouble(),
              ),
              onBothChanged: (v) => settings.update(() {
                settings.horizontalMargin = v.floorToDouble();
                settings.verticalMargin = v.floorToDouble();
              }),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Builds a new [WidgetDecoration] when switching types,
  /// preserving border radius from the previous decoration.
  WidgetDecoration _buildDecoration(
    WidgetBackgroundType type,
    WidgetDecoration previous,
  ) {
    return switch (type) {
      WidgetBackgroundType.none => const NoDecoration(),
      WidgetBackgroundType.color => ColorDecoration(
        color: previous is ColorDecoration ? previous.color : const Color(0xFF000000),
        opacity: previous is ColorDecoration ? previous.opacity : 0.5,
        borderRadius: previous.borderRadius,
      ),
      WidgetBackgroundType.glass => GlassDecoration(
        tint: previous is GlassDecoration ? previous.tint : const Color(0x80FFFFFF),
        tintOpacity: previous is GlassDecoration ? previous.tintOpacity : 0.15,
        blur: previous is GlassDecoration ? previous.blur : 20,
        borderRadius: previous.borderRadius,
      ),
      WidgetBackgroundType.border => BorderDecoration(
        color: previous is BorderDecoration ? previous.color : const Color(0xFFFFFFFF),
        opacity: previous is BorderDecoration ? previous.opacity : 0.3,
        thickness: previous is BorderDecoration ? previous.thickness : 1,
        borderRadius: previous.borderRadius,
      ),
    };
  }

  WidgetDecoration _copyWithBorderRadius(
    WidgetDecoration decoration,
    double borderRadius,
  ) {
    return switch (decoration) {
      NoDecoration() => const NoDecoration(),
      ColorDecoration d => ColorDecoration(
        color: d.color,
        opacity: d.opacity,
        borderRadius: borderRadius,
        imageColorId: d.imageColorId,
      ),
      GlassDecoration d => GlassDecoration(
        tint: d.tint,
        tintOpacity: d.tintOpacity,
        blur: d.blur,
        borderRadius: borderRadius,
        imageColorId: d.imageColorId,
      ),
      BorderDecoration d => BorderDecoration(
        color: d.color,
        opacity: d.opacity,
        thickness: d.thickness,
        borderRadius: borderRadius,
        imageColorId: d.imageColorId,
      ),
    };
  }
}

class _ColorDecorationControls extends StatelessWidget {
  final ColorDecoration decoration;
  final CommonWidgetSettingsAccessor settings;

  const _ColorDecorationControls({
    required this.decoration,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Color',
          builder: (context) {
            return _ColorSwatchPicker(
              selectedColor: decoration.color,
              selectedImageColorId: decoration.imageColorId,
              onSelected: (color, imageColorId) {
                settings.update(() {
                  settings.decoration = ColorDecoration(
                    color: color,
                    opacity: decoration.opacity,
                    borderRadius: decoration.borderRadius,
                    imageColorId: imageColorId,
                  );
                });
              },
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Opacity',
          builder: (context) {
            return CustomSlider(
              min: 0,
              max: 1,
              valueLabel: '${(decoration.opacity * 100).floor()}%',
              value: decoration.opacity,
              onChanged: (value) {
                settings.update(() {
                  settings.decoration = ColorDecoration(
                    color: decoration.color,
                    opacity: value,
                    borderRadius: decoration.borderRadius,
                    imageColorId: decoration.imageColorId,
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }
}

class _GlassDecorationControls extends StatelessWidget {
  final GlassDecoration decoration;
  final CommonWidgetSettingsAccessor settings;

  const _GlassDecorationControls({
    required this.decoration,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Tint',
          builder: (context) {
            return _ColorSwatchPicker(
              selectedColor: decoration.tint,
              selectedImageColorId: decoration.imageColorId,
              onSelected: (color, imageColorId) {
                settings.update(() {
                  settings.decoration = GlassDecoration(
                    tint: color,
                    tintOpacity: decoration.tintOpacity,
                    blur: decoration.blur,
                    borderRadius: decoration.borderRadius,
                    imageColorId: imageColorId,
                  );
                });
              },
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Tint Opacity',
          builder: (context) {
            return CustomSlider(
              min: 0,
              max: 1,
              valueLabel: '${(decoration.tintOpacity * 100).floor()}%',
              value: decoration.tintOpacity,
              onChanged: (value) {
                settings.update(() {
                  settings.decoration = GlassDecoration(
                    tint: decoration.tint,
                    tintOpacity: value,
                    blur: decoration.blur,
                    borderRadius: decoration.borderRadius,
                    imageColorId: decoration.imageColorId,
                  );
                });
              },
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Blur',
          builder: (context) {
            return CustomSlider(
              min: 0,
              max: 50,
              valueLabel: '${decoration.blur.floor()} px',
              value: decoration.blur,
              onChanged: (value) {
                settings.update(() {
                  settings.decoration = GlassDecoration(
                    tint: decoration.tint,
                    tintOpacity: decoration.tintOpacity,
                    blur: value.floorToDouble(),
                    borderRadius: decoration.borderRadius,
                    imageColorId: decoration.imageColorId,
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }
}

class _BorderDecorationControls extends StatelessWidget {
  final BorderDecoration decoration;
  final CommonWidgetSettingsAccessor settings;

  const _BorderDecorationControls({
    required this.decoration,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Color',
          builder: (context) {
            return _ColorSwatchPicker(
              selectedColor: decoration.color,
              selectedImageColorId: decoration.imageColorId,
              onSelected: (color, imageColorId) {
                settings.update(() {
                  settings.decoration = BorderDecoration(
                    color: color,
                    opacity: decoration.opacity,
                    thickness: decoration.thickness,
                    borderRadius: decoration.borderRadius,
                    imageColorId: imageColorId,
                  );
                });
              },
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Opacity',
          builder: (context) {
            return CustomSlider(
              min: 0,
              max: 1,
              valueLabel: '${(decoration.opacity * 100).floor()}%',
              value: decoration.opacity,
              onChanged: (value) {
                settings.update(() {
                  settings.decoration = BorderDecoration(
                    color: decoration.color,
                    opacity: value,
                    thickness: decoration.thickness,
                    borderRadius: decoration.borderRadius,
                    imageColorId: decoration.imageColorId,
                  );
                });
              },
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Thickness',
          builder: (context) {
            return CustomSlider(
              min: 0.5,
              max: 100,
              valueLabel: '${decoration.thickness.toStringAsFixed(1)} px',
              value: decoration.thickness,
              onChanged: (value) {
                settings.update(() {
                  settings.decoration = BorderDecoration(
                    color: decoration.color,
                    opacity: decoration.opacity,
                    thickness: value,
                    borderRadius: decoration.borderRadius,
                    imageColorId: decoration.imageColorId,
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }
}

/// A compact color picker that shows:
/// 1. Colors extracted from the current background image (if available)
/// 2. A set of standard preset swatches
///
/// When the user picks an image color, the callback includes the color's
/// stable ID so the decoration can auto-update when the image changes.
class _ColorSwatchPicker extends StatelessWidget {
  final Color selectedColor;
  final String? selectedImageColorId;
  final void Function(Color color, String? imageColorId) onSelected;

  const _ColorSwatchPicker({
    required this.selectedColor,
    required this.selectedImageColorId,
    required this.onSelected,
  });

  static const List<Color> _presets = [
    Color(0xFF000000),
    Color(0xFF1A1A1A),
    Color(0xFF333333),
    Color(0xFF666666),
    Color(0xFF999999),
    Color(0xFFCCCCCC),
    Color(0xFFFFFFFF),
    Color(0xFF0A84FF), // system blue
    Color(0xFFFF453A), // system red
    Color(0xFFFF9F0A), // system orange
    Color(0xFF30D158), // system green
    Color(0xFFBF5AF2), // system purple
  ];

  @override
  Widget build(BuildContext context) {
    final backgroundStore = context.read<BackgroundStore>();

    return CustomObserver(
      name: 'ColorSwatchPicker',
      builder: (context) {
        final imageColors = backgroundStore.imageColors;

        final isExtracting = backgroundStore.extractingPalette;
        final showImageSection = imageColors.isNotEmpty || isExtracting;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showImageSection) ...[
              Row(
                children: [
                  Text(
                    'FROM IMAGE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.6,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 14,
                      onPressed: isExtracting ? null : () => backgroundStore.refreshPaletteColors(),
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: Colors.white.withValues(alpha: isExtracting ? 0.15 : 0.3),
                      ),
                      splashRadius: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (isExtracting)
                const _PaletteLoadingSkeleton()
              else
                _buildImageSwatches(context, imageColors),
              const SizedBox(height: 12),
              Text(
                'PRESETS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.6,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: 8),
            ],
            _buildPresetSwatches(context),
          ],
        );
      },
    );
  }

  Widget _buildImageSwatches(BuildContext context, Map<String, Color> imageColors) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: imageColors.entries.map((entry) {
        final bool isSelected = selectedImageColorId == entry.key;
        return _buildSwatch(
          context,
          color: entry.value,
          isSelected: isSelected,
          onTap: () => onSelected(entry.value, entry.key),
        );
      }).toList(),
    );
  }

  Widget _buildPresetSwatches(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _presets.map((color) {
        final bool isSelected = selectedImageColorId == null && selectedColor.toARGB32() == color.toARGB32();
        return _buildSwatch(
          context,
          color: color,
          isSelected: isSelected,
          onTap: () => onSelected(color, null),
        );
      }).toList(),
    );
  }

  Widget _buildSwatch(
    BuildContext context, {
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white.withValues(alpha: 0.15),
            width: isSelected ? 2 : 0.5,
          ),
        ),
      ),
    );
  }
}

/// A linked slider pair for horizontal/vertical values.
/// Starts as a single unified slider. A link toggle splits it
/// into independent H/V sliders.
class _LinkedSliderPair extends StatefulWidget {
  final double horizontalValue;
  final double verticalValue;
  final double max;
  final ValueChanged<double> onHorizontalChanged;
  final ValueChanged<double> onVerticalChanged;
  final ValueChanged<double> onBothChanged;

  const _LinkedSliderPair({
    required this.horizontalValue,
    required this.verticalValue,
    required this.max,
    required this.onHorizontalChanged,
    required this.onVerticalChanged,
    required this.onBothChanged,
  });

  @override
  State<_LinkedSliderPair> createState() => _LinkedSliderPairState();
}

class _LinkedSliderPairState extends State<_LinkedSliderPair> {
  late bool _linked = widget.horizontalValue == widget.verticalValue;

  @override
  Widget build(BuildContext context) {
    if (_linked) {
      return Row(
        children: [
          Expanded(
            child: CustomSlider(
              min: 0,
              max: widget.max,
              valueLabel: '${widget.horizontalValue.floor()} px',
              value: widget.horizontalValue,
              onChanged: widget.onBothChanged,
            ),
          ),
          const SizedBox(width: 4),
          _buildLinkToggle(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomSlider(
                min: 0,
                max: widget.max,
                valueLabel: 'H ${widget.horizontalValue.floor()} px',
                value: widget.horizontalValue,
                onChanged: widget.onHorizontalChanged,
              ),
            ),
            const SizedBox(width: 4),
            _buildLinkToggle(),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: CustomSlider(
                min: 0,
                max: widget.max,
                valueLabel: 'V ${widget.verticalValue.floor()} px',
                value: widget.verticalValue,
                onChanged: widget.onVerticalChanged,
              ),
            ),
            // Spacer for the link button width so sliders align.
            const SizedBox(width: 36),
          ],
        ),
      ],
    );
  }

  Widget _buildLinkToggle() {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 16,
        tooltip: _linked ? 'Separate horizontal & vertical' : 'Link horizontal & vertical',
        onPressed: () {
          setState(() {
            _linked = !_linked;
            if (_linked) {
              // Sync both to the horizontal value.
              widget.onBothChanged(widget.horizontalValue);
            }
          });
        },
        icon: Icon(
          _linked ? Icons.link_rounded : Icons.link_off_rounded,
          color: Colors.white.withValues(alpha: _linked ? 0.5 : 0.25),
        ),
      ),
    );
  }
}

/// Skeleton loader shown while palette colors are being extracted.
/// Each ghost box has a diagonal shimmer highlight that sweeps across it,
/// staggered per box so the light cascades left-to-right across the row.
class _PaletteLoadingSkeleton extends StatefulWidget {
  const _PaletteLoadingSkeleton();

  @override
  State<_PaletteLoadingSkeleton> createState() => _PaletteLoadingSkeletonState();
}

class _PaletteLoadingSkeletonState extends State<_PaletteLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const count = 8;
    // Stagger delay per box so the shimmer cascades across the row.
    const staggerFraction = 0.06;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(count, (i) {
            // Offset the animation phase per box.
            final delayed = (_controller.value - i * staggerFraction) % 1.0;

            return _ShimmerBox(t: delayed);
          }),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double t;

  const _ShimmerBox({required this.t});

  @override
  Widget build(BuildContext context) {
    // The shimmer band sweeps from left (-1) to right (+2) across the box.
    // We map t (0→1) to that range.
    final shimmerCenter = -1.0 + t * 3.0;

    return SizedBox(
      width: 28,
      height: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            begin: Alignment(shimmerCenter - 0.6, -0.3),
            end: Alignment(shimmerCenter + 0.6, 0.3),
            colors: const [
              Color(0x0FFFFFFF), // base
              Color(0x28FFFFFF), // highlight
              Color(0x0FFFFFFF), // base
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}
