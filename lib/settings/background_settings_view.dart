import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/background_model.dart';
import '../model/background_settings.dart';
import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../model/unsplash_collection.dart';
import '../resources/color_gradients.dart';
import '../resources/flat_colors.dart';
import '../resources/unsplash_sources.dart';
import '../ui/custom_dropdown.dart';
import '../ui/custom_slider.dart';
import '../ui/custom_switch.dart';
import '../ui/gesture_detector_with_cursor.dart';
import '../utils/extensions.dart';

class BackgroundSettingsView extends StatelessWidget {
  const BackgroundSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundModelBase>(builder: (context, model, child) {
      if (!model.initialized) return const SizedBox(height: 200);
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Background Mode'),
          const SizedBox(height: 10),
          CupertinoTheme(
            data: const CupertinoThemeData(
              primaryContrastingColor: Colors.white,
              primaryColor: Colors.black,
            ),
            child: CupertinoSegmentedControl<BackgroundMode>(
              padding: EdgeInsets.zero,
              groupValue: model.mode,
              selectedColor: Colors.black,
              borderColor: Colors.black,
              onValueChanged: (mode) => model.setMode(mode),
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
          // const SizedBox(height: 16),
          // CustomDropdown<BackgroundMode>(
          //   value: model.mode,
          //   label: 'Background Mode',
          //   isExpanded: true,
          //   items: BackgroundMode.values,
          //   itemBuilder: (context, item) => Text(item.label),
          //   onSelected: (mode) => model.setMode(mode),
          // ),
          const SizedBox(height: 16),
          if (model.mode.isColor) ...[
            CustomDropdown<FlatColor>(
              value: model.color,
              label: 'Color',
              isExpanded: true,
              itemHeight: 40,
              items: FlatColors.colors.values.toList(),
              itemBuilder: (context, item) => Row(
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
              ),
              onSelected: (color) => model.setColor(color),
            ),
            // const SizedBox(height: 16),
            // ColorsGridView(
            //   value: model.color,
            //   items: FlatColors.colors.values.toList(),
            //   onSelected: (color) => model.setColor(color),
            // ),
          ],
          if (model.mode.isGradient) ...[
            CustomDropdown<ColorGradient>(
              value: model.gradient,
              label: 'Gradient',
              isExpanded: true,
              itemHeight: 40,
              searchable: true,
              searchMatchFn: (item, query) => (item.value as ColorGradient)
                  .name
                  .toLowerCase()
                  .contains(query.toLowerCase()),
              items: ColorGradients.gradients.values.toList(),
              itemBuilder: (context, item) => Row(
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
              ),
              onSelected: (gradient) => model.setGradient(gradient),
            ),
            // const SizedBox(height: 16),
            // GradientsGridView(
            //   value: model.gradient,
            //   items: ColorGradients.gradients.values.toList(),
            //   onSelected: (gradient) => model.setGradient(gradient),
            // ),
          ],
          if (model.mode.isImage) const ImageSettings(),
          if (model.mode.isImage) ...[
            const SizedBox(height: 16),
            CustomSwitch(
              label: 'Black & White Filter',
              value: model.greyScale,
              onChanged: (value) {
                model.setGreyScale(value);
              },
            ),
          ],
          const SizedBox(height: 16),
          CustomSlider(
            label: 'Tint',
            value: model.tint,
            min: 0,
            max: 100,
            valueLabel: '${model.tint.floor().toString()} %',
            onChanged: (value) => model.setTint(value),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetectorWithCursor(
                onTap: () => model.setTexture(!model.texture),
                tooltip: 'Texture',
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.lens_blur_rounded,
                    color: model.texture ? Colors.black : Colors.grey.shade400,
                    size: 20,
                  ),
                ),
              ),
              if (model.mode.isImage) ...[
                const SizedBox(width: 16),
                GestureDetectorWithCursor(
                  onTap: () => model.setInvert(!model.invert),
                  tooltip: 'Invert',
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.brightness_medium_rounded,
                      color: model.invert ? Colors.black : Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetectorWithCursor(
                  onTap: !model.isLoadingImage ? model.changeBackground : null,
                  tooltip: 'Change Background',
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ImageIcon(
                      AssetImage(model.isLoadingImage
                          ? 'assets/images/ic_hourglass.png'
                          : 'assets/images/ic_fan.png'),
                      color: model.isLoadingImage
                          ? Colors.grey.shade400
                          : Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetectorWithCursor(
                  onTap: !model.isLoadingImage ? model.onDownload : null,
                  tooltip: 'Download Image',
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.download_rounded,
                      color: model.isLoadingImage || model.getImage() == null
                          ? Colors.grey.shade400
                          : Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetectorWithCursor(
                  onTap: !model.isLoadingImage ? model.onOpenImage : null,
                  tooltip: 'Open Original Image',
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.open_in_new_rounded,
                      color: model.isLoadingImage || model.getImage() == null
                          ? Colors.grey.shade400
                          : Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}

class ColorsGridView extends StatelessWidget {
  final List<FlatColor> items;
  final ValueChanged<FlatColor> onSelected;
  final FlatColor? value;

  const ColorsGridView({
    super.key,
    required this.items,
    required this.onSelected,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Colors'),
        GridView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          children: [
            for (final item in items)
              GestureDetector(
                onTap: () => onSelected(item),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          // width: 0.5,
                        ),
                      ),
                      color: item.background,
                    ),
                    child: value == item
                        ? Icon(Icons.done, color: item.foreground)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class GradientsGridView extends StatelessWidget {
  final List<ColorGradient> items;
  final ValueChanged<ColorGradient> onSelected;
  final ColorGradient? value;

  const GradientsGridView({
    super.key,
    required this.items,
    required this.onSelected,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Gradients'),
        GridView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          children: [
            for (final item in items)
              GestureDetector(
                onTap: () => onSelected(item),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        // width: 0.5,
                      ),
                      gradient: item.toLinearGradient(),
                    ),
                    child: value == item
                        ? Icon(Icons.done, color: item.foreground)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class ImageSettings extends StatelessWidget {
  const ImageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundModelBase>(builder: (context, model, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Builder(builder: (context) {
            switch (model.imageSource) {
              case ImageSource.unsplash:
                return const UnsplashSourceSettings();
              case ImageSource.local:
                return const SizedBox.shrink();
            }
          }),
          const SizedBox(height: 16),
          CustomDropdown<ImageRefreshRate>(
            value: model.imageRefreshRate,
            label: 'Auto Refresh Background',
            isExpanded: true,
            items: ImageRefreshRate.values,
            itemBuilder: (context, item) => Text(item.label),
            onSelected: (value) => model.setImageRefreshRate(value),
          ),
        ],
      );
    });
  }
}

class UnsplashSourceSettings extends StatelessWidget {
  const UnsplashSourceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundModelBase>(builder: (context, model, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDropdown<UnsplashSource>(
            value: model.unsplashSource,
            label: 'Background Collection',
            isExpanded: true,
            items: UnsplashSources.sources,
            itemBuilder: (context, item) => Text(item.name),
            onSelected: (value) => model.setUnsplashSource(value),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: Text('Resolution')),
              ResolutionHelpButton(),
              SizedBox(width: 4),
            ],
          ),
          const SizedBox(height: 10),
          CustomDropdown<ImageResolution>(
            value: model.imageResolution,
            isExpanded: true,
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
            onSelected: (value) => model.setImageResolution(value),
          ),
        ],
      );
    });
  }
}

class ResolutionHelpButton extends StatelessWidget {
  const ResolutionHelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Tooltip(
      padding: EdgeInsets.all(14),
      richMessage: TextSpan(
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
      margin: EdgeInsets.only(right: 32),
      triggerMode: TooltipTriggerMode.tap,
      textAlign: TextAlign.start,
      preferBelow: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(
          Icons.info_outline_rounded,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
