import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/background_settings.dart';
import '../resources/colors.dart';
import '../resources/storage_keys.dart';
import '../ui/custom_dropdown.dart';
import '../utils/storage_manager.dart';

class AdvancedSettingsDialog extends StatefulWidget {
  const AdvancedSettingsDialog({super.key});

  @override
  State<AdvancedSettingsDialog> createState() => _AdvancedSettingsDialogState();
}

class _AdvancedSettingsDialogState extends State<AdvancedSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: min(400, MediaQuery.of(context).size.width * 0.9),
          height: min(500, MediaQuery.of(context).size.height * 0.9),
          decoration: BoxDecoration(
            color: AppColors.settingsPanelBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 8, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Advanced Settings',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        splashRadius: 16,
                        iconSize: 18,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    children: [
                      ImageDownloadQualitySetting(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageDownloadQualitySetting extends StatefulWidget {
  const ImageDownloadQualitySetting({super.key});

  @override
  State<ImageDownloadQualitySetting> createState() =>
      _ImageDownloadQualitySettingState();
}

class _ImageDownloadQualitySettingState
    extends State<ImageDownloadQualitySetting> {
  late final LocalStorageManager storage =
      GetIt.instance.get<LocalStorageManager>();

  ImageResolution resolution = ImageResolution.auto;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    resolution = await storage.getEnum<ImageResolution>(
          StorageKeys.imageDownloadQuality,
          ImageResolution.values,
        ) ??
        ImageResolution.auto;

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomDropdown<ImageResolution>(
          value: resolution,
          label: 'Image Download Quality',
          hint: 'Select duration',
          isExpanded: true,
          items: ImageResolution.values,
          itemBuilder: (context, item) => Text(item.label),
          onSelected: (value) {
            if (resolution == value) return;
            resolution = value;
            storage.setEnum(StorageKeys.imageDownloadQuality, resolution);
            setState(() {});
            // store.setImageRefreshRate(value);
          },
        ),
      ],
    );
  }
}
