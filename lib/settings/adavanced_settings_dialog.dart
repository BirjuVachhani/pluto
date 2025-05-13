import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:screwdriver/screwdriver.dart';
import 'package:shared/shared.dart';

import '../home/background_store.dart';
import '../model/background_settings.dart';
import '../resources/colors.dart';
import '../resources/storage_keys.dart';
import '../ui/custom_dropdown.dart';
import '../ui/gesture_detector_with_cursor.dart';
import '../utils/custom_observer.dart';
import '../utils/storage_manager.dart';
import 'new_collection_dialog.dart';

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
          constraints: BoxConstraints(
            maxHeight: min(500, MediaQuery.of(context).size.height * 0.9),
          ),
          decoration: BoxDecoration(
            color: AppColors.settingsPanelBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
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
              const Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ImageDownloadQualitySetting(),
                      SizedBox(height: 16),
                      CustomCollectionsSettings(),
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

class CustomCollectionsSettings extends StatelessWidget {
  const CustomCollectionsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<BackgroundStore>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('Custom Collections'),
            const Spacer(),
            GestureDetectorWithCursor(
              onTap: () => onCreateNewCollection(context, store),
              child: Icon(
                Icons.add_circle_rounded,
                size: 18,
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, thickness: 1),
        CustomObserver(
          name: 'Custom Collections List',
          builder: (context) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: store.customSources.length,
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (context, index) {
                final bool selected = store.unsplashSource.name ==
                    store.customSources[index].name;
                return Hoverable(
                  key: ValueKey(index),
                  builder: (context, hovering, child) {
                    return Container(
                      color: selected
                          ? context.colorScheme.primary.withValues(alpha: 0.1)
                          : hovering
                              ? context.colorScheme.onSurface
                                  .withValues(alpha: 0.05)
                              : null,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              store.customSources[index].name,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          if (!selected && hovering)
                            GestureDetectorWithCursor(
                              onTap: () {
                                store.removeCustomCollection(
                                    store.customSources[index]);
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.colorScheme.primary,
                                ),
                              ),
                            ),
                          if (selected)
                            const Icon(
                              Icons.done,
                              color: Colors.green,
                              size: 16,
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
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
        setAsCurrent: false,
      );
    }
  }
}
