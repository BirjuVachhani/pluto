import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screwdriver/screwdriver.dart';

import '../home/background_store.dart';
import '../model/background_settings.dart';
import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../model/unsplash_collection.dart';
import '../resources/color_gradients.dart';
import '../resources/colors.dart';
import '../resources/flat_colors.dart';
import '../resources/unsplash_sources.dart';
import '../ui/custom_dropdown.dart';
import '../ui/custom_slider.dart';
import '../ui/custom_switch.dart';
import '../ui/gesture_detector_with_cursor.dart';
import '../utils/custom_observer.dart';
import '../utils/extensions.dart';
import 'new_collection_dialog.dart';

class BackgroundSettingsView extends StatelessWidget {
  const BackgroundSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final BackgroundStore store = context.read<BackgroundStore>();
    return CustomObserver(
      name: 'BackgroundSettingsView',
      builder: (context) {
        if (!store.initialized) return const SizedBox(height: 200);
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BackgroundModeSelector(),
            const SizedBox(height: 16),
            const _ColorSelector(),
            const _GradientSelector(),
            CustomObserver(
              name: 'ImageSettings',
              builder: (context) {
                if (!store.isImageMode) return const SizedBox.shrink();
                return const ImageSettings();
              },
            ),
            const SizedBox(height: 16),
            LabeledObserver(
              label: 'Auto Refresh Background',
              builder: (context) {
                return CustomDropdown<BackgroundRefreshRate>(
                  value: store.backgroundRefreshRate,
                  hint: 'Select duration',
                  isExpanded: true,
                  items: BackgroundRefreshRate.values,
                  itemBuilder: (context, item) => Text(item.label),
                  onSelected: (value) => store.setImageRefreshRate(value),
                );
              },
            ),
            const SizedBox(height: 16),
            LabeledObserver(
              label: 'Tint',
              builder: (context) => CustomSlider(
                value: store.tint,
                min: 0,
                max: 100,
                valueLabel: '${store.tint.floor().toString()} %',
                onChanged: (value) => store.setTint(value),
              ),
            ),
            const SizedBox(height: 40),
            const _BackgroundOptions(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _BackgroundOptions extends StatelessWidget {
  const _BackgroundOptions();

  @override
  Widget build(BuildContext context) {
    final store = context.read<BackgroundStore>();
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomObserver(
          name: 'Texture',
          builder: (context) {
            return GestureDetectorWithCursor(
              onTap: () => store.setTexture(!store.texture),
              tooltip: 'Texture',
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.lens_blur_rounded,
                  color: store.texture
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.textColor.withOpacity(0.5),
                  size: 20,
                ),
              ),
            );
          },
        ),
        if (!store.mode.isImage) ...[
          const SizedBox(width: 16),
          CustomObserver(
            name: 'Change Background',
            builder: (context) {
              return GestureDetectorWithCursor(
                onTap: !store.isLoadingImage ? store.onChangeBackground : null,
                tooltip: 'Change Background',
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ImageIcon(
                    AssetImage(store.isLoadingImage
                        ? 'assets/images/ic_hourglass.png'
                        : 'assets/images/ic_fan.png'),
                    color: store.isLoadingImage
                        ? Colors.grey.withOpacity(0.5)
                        : AppColors.textColor.withOpacity(0.5),
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ],
        CustomObserver(
          name: 'Image background options',
          builder: (context) {
            if (!store.mode.isImage) return const SizedBox.shrink();
            return const _ImageBackgroundOptions();
          },
        ),
      ],
    );
  }
}

class _ImageBackgroundOptions extends StatelessWidget {
  const _ImageBackgroundOptions();

  @override
  Widget build(BuildContext context) {
    final store = context.read<BackgroundStore>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 16),
        CustomObserver(
          name: 'Invert',
          builder: (context) {
            return GestureDetectorWithCursor(
              onTap: () => store.setInvert(!store.invert),
              tooltip: 'Invert',
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.brightness_medium_rounded,
                  color: store.invert
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.textColor.withOpacity(0.5),
                  size: 20,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        CustomObserver(
          name: 'Change Background',
          builder: (context) {
            return GestureDetectorWithCursor(
              onTap: !store.isLoadingImage ? store.onChangeBackground : null,
              tooltip: 'Change Background',
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ImageIcon(
                  AssetImage(store.isLoadingImage
                      ? 'assets/images/ic_hourglass.png'
                      : 'assets/images/ic_fan.png'),
                  color: store.isLoadingImage
                      ? Colors.grey.withOpacity(0.5)
                      : AppColors.textColor.withOpacity(0.5),
                  size: 20,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        CustomObserver(
          name: 'Download Background',
          builder: (context) {
            return GestureDetectorWithCursor(
              onTap: !store.isLoadingImage ? store.onDownload : null,
              tooltip: 'Download Image',
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.download_rounded,
                  color: store.isLoadingImage || store.currentImage == null
                      ? Colors.grey.withOpacity(0.5)
                      : AppColors.textColor.withOpacity(0.5),
                  size: 20,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        CustomObserver(
          name: 'Open Image',
          builder: (context) {
            return GestureDetectorWithCursor(
              onTap: !store.isLoadingImage ? store.onOpenImage : null,
              tooltip: 'Open Original Image',
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.open_in_new_rounded,
                  color: store.isLoadingImage || store.currentImage == null
                      ? Colors.grey.withOpacity(0.5)
                      : AppColors.textColor.withOpacity(0.5),
                  size: 20,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class BackgroundModeSelector extends StatelessWidget {
  const BackgroundModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<BackgroundStore>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Background Mode'),
        const SizedBox(height: 10),
        CupertinoTheme(
          data: CupertinoThemeData(
            brightness: Brightness.dark,
            primaryColor: Theme.of(context).colorScheme.primary,
            primaryContrastingColor: AppColors.settingsPanelBackgroundColor,
          ),
          child: CustomObserver(
            name: 'BackgroundModeSelector',
            builder: (context) => CupertinoSegmentedControl<BackgroundMode>(
              padding: EdgeInsets.zero,
              groupValue: store.mode,
              onValueChanged: (mode) => store.setMode(mode),
              children: {
                for (final mode in BackgroundMode.values)
                  mode: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      mode.label,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ImageSettings extends StatelessWidget {
  const ImageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final BackgroundStore store = context.read<BackgroundStore>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _ImageSourceSelector(),
        const SizedBox(height: 16),
        CustomObserver(
          name: 'Image Source Settings',
          builder: (context) {
            switch (store.imageSource) {
              case ImageSource.unsplash:
                return const UnsplashSourceSettings();
              case ImageSource.local:
                return const SizedBox.shrink();
              case ImageSource.userLikes:
                return const SizedBox.shrink();
            }
          },
        ),
        CustomObserver(
          name: 'B&W Filter',
          builder: (context) {
            return CustomSwitch(
              label: 'Black & White Filter',
              value: store.greyScale,
              onChanged: (value) {
                store.setGreyScale(value);
              },
            );
          },
        ),
      ],
    );
  }
}

class _ImageSourceSelector extends StatefulWidget {
  const _ImageSourceSelector();

  @override
  State<_ImageSourceSelector> createState() => _ImageSourceSelectorState();
}

class _ImageSourceSelectorState extends State<_ImageSourceSelector> {
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    final store = context.read<BackgroundStore>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('Source'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CustomObserver(
                  name: 'Image Source Header',
                  builder: (context) {
                    if (showError) {
                      return const Text(
                        'Please like few backgrounds first! ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }
                    if (store.imageSource != ImageSource.userLikes) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      '${store.likedBackgrounds.length} liked',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomObserver(
          name: 'Image Source Selector',
          builder: (context) {
            return CustomDropdown<ImageSource>(
              value: store.imageSource,
              // label: 'Source',
              hint: 'Select source',
              isExpanded: true,
              items: ImageSource.values.except([ImageSource.local]).toList(),
              itemBuilder: (context, item) => Text(
                item.label,
                style: TextStyle(
                  color: item == ImageSource.userLikes &&
                          store.likedBackgrounds.isEmpty
                      ? Colors.grey.shade400
                      : null,
                ),
              ),
              onSelected: (value) {
                if (value == ImageSource.userLikes &&
                    store.likedBackgrounds.isEmpty) {
                  triggerError();
                  return;
                }
                store.setImageSource(value);
              },
            );
          },
        ),
      ],
    );
  }

  void triggerError() {
    setState(() => showError = true);
    Future.delayed(const Duration(seconds: 3), () {
      showError = false;
      if (mounted) setState(() {});
    });
  }
}

class UnsplashSourceSettings extends StatelessWidget {
  const UnsplashSourceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final BackgroundStore store = context.read<BackgroundStore>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text('Background Collection', style: TextStyle(height: 1)),
            const SizedBox(width: 6),
            CustomObserver(
              name: 'Add Collection',
              builder: (context) {
                if (store.imageSource != ImageSource.unsplash) {
                  return const SizedBox.shrink();
                }
                return GestureDetectorWithCursor(
                  onTap: () => onCreateNewCollection(context, store),
                  child: Icon(
                    Icons.add_circle_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomObserver(
          name: 'Background Collection',
          builder: (context) {
            return CustomDropdown<UnsplashSource>(
              value: store.unsplashSource,
              hint: 'Select a collection',
              isExpanded: true,
              items: [...store.customSources, ...UnsplashSources.sources],
              itemBuilder: (context, item) {
                if (item == UnsplashSources.christmas) {
                  return Text('🎄${item.name}');
                }
                return Text(item.name);
              },
              onSelected: (value) => store.setUnsplashSource(value),
            );
          },
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(child: Text('Resolution')),
            ResolutionHelpButton(),
            SizedBox(width: 4),
          ],
        ),
        const SizedBox(height: 10),
        CustomObserver(
          name: 'Resolution Selector',
          builder: (context) {
            return CustomDropdown<ImageResolution>(
              value: store.imageResolution,
              isExpanded: true,
              hint: 'Select a resolution',
              items: ImageResolution.values,
              itemBuilder: (context, item) => Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: item.label),
                    const WidgetSpan(child: SizedBox(width: 8)),
                    TextSpan(
                      text: '(${item.sizeLabel})',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              selectedItemBuilder: (context, item) => Text(item.label),
              onSelected: (value) => store.setImageResolution(value),
            );
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> onCreateNewCollection(
      BuildContext context, BackgroundStore store) async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context),
        child: NewCollectionDialog(store: store),
      ),
    );
    if (result != null) {
      store.addNewCollection(
          UnsplashTagsSource(tags: result.trim().capitalized),
          setAsCurrent: true);
    }
  }
}

class ResolutionHelpButton extends StatelessWidget {
  const ResolutionHelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      padding: const EdgeInsets.all(14),
      richMessage: const TextSpan(
        text: '',
        children: [
          TextSpan(
            text: 'Auto Mode: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          TextSpan(
            text:
                'Background images will have\nsame resolution as this window.\n',
            style: TextStyle(height: 1.3, fontSize: 13),
          ),
          TextSpan(
            text: '\nNote: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          TextSpan(
            text:
                'Higher resolution background may\ntake more time to load depending on\nyour connection.',
            style: TextStyle(height: 1.3, fontSize: 13),
          ),
        ],
      ),
      margin: const EdgeInsets.only(right: 32),
      triggerMode: TooltipTriggerMode.tap,
      textAlign: TextAlign.start,
      preferBelow: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(
          Icons.info_outline_rounded,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  const _ColorSelector();

  @override
  Widget build(BuildContext context) {
    final store = context.read<BackgroundStore>();
    return CustomObserver(
      name: 'ColorSelector',
      builder: (context) {
        if (!store.isColorMode) return const SizedBox.shrink();
        return CustomDropdown<FlatColor>(
          value: store.color,
          label: 'Color',
          hint: 'Select a color',
          isExpanded: true,
          itemHeight: 40,
          items: FlatColors.colors.values.toList(),
          itemBuilder: (context, item) => _ColorSelectorItem(
            key: ValueKey(item),
            item: item,
          ),
          onSelected: (color) => store.setColor(color),
        );
      },
    );
  }
}

class _ColorSelectorItem extends StatelessWidget {
  final FlatColor item;

  const _ColorSelectorItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: item.background,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(item.name)),
      ],
    );
  }
}

class _GradientSelector extends StatelessWidget {
  const _GradientSelector();

  @override
  Widget build(BuildContext context) {
    final store = context.read<BackgroundStore>();
    return CustomObserver(
      name: 'ColorGradientSelector',
      builder: (context) {
        if (!store.isGradientMode) return const SizedBox.shrink();
        return CustomDropdown<ColorGradient>(
          value: store.gradient,
          label: 'Gradient',
          hint: 'Select a gradient',
          isExpanded: true,
          itemHeight: 40,
          items: ColorGradients.gradients.values.toList(),
          itemBuilder: (context, item) => _GradientSelectorItem(
            key: ValueKey(item),
            item: item,
          ),
          onSelected: (gradient) => store.setGradient(gradient),
        );
      },
    );
  }
}

class _GradientSelectorItem extends StatelessWidget {
  final ColorGradient item;

  const _GradientSelectorItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: item.toLinearGradient(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(item.name)),
      ],
    );
  }
}
