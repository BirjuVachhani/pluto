import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home/background_store.dart';
import '../home/home_store.dart';
import '../home/widget_store.dart';
import '../resources/colors.dart';
import '../resources/storage_keys.dart';
import '../utils/custom_observer.dart';
import '../utils/dropdown_button3.dart';
import '../utils/storage_manager.dart';
import 'about.dart';
import 'background_settings_view.dart';
import 'changelog_dialog.dart';
import 'liked_backgrounds_dialog.dart';
import 'widget_settings.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<HomeStore>();
    return CustomObserver(
      name: 'SettingsPanel',
      builder: (context) {
        if (!store.initialized || !store.isPanelVisible) {
          return const SizedBox.shrink();
        }
        return const Stack(
          fit: StackFit.expand,
          children: [
            _BackgroundDismissible(),
            Positioned(
              top: 32,
              right: 32,
              bottom: 32,
              child: SettingsPanelContent(),
            ),
          ],
        );
      },
    );
  }
}

class SettingsPanelContent extends StatefulWidget {
  const SettingsPanelContent({super.key});

  @override
  State<SettingsPanelContent> createState() => _SettingsPanelContentState();
}

class _SettingsPanelContentState extends State<SettingsPanelContent>
    with SingleTickerProviderStateMixin {
  late final HomeStore store = context.read<HomeStore>();

  @override
  void initState() {
    super.initState();
    store.tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: store.currentTabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            width: 360,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.settingsPanelBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 8, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Settings',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const MenuButton(),
                      Material(
                        type: MaterialType.transparency,
                        child: IconButton(
                          onPressed: () => store.hidePanel(),
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
                Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0.5,
                      child: Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 360,
                      child: TabBar(
                        controller: store.tabController,
                        // unselectedLabelColor: Colors.black,
                        labelColor: Theme.of(context).primaryColor,
                        isScrollable: true,
                        unselectedLabelColor: AppColors.textColor,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        indicator: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 0.5,
                            ),
                            left: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 0.5,
                            ),
                            right: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 0.5,
                            ),
                            bottom: const BorderSide(
                              color: AppColors.settingsPanelBackgroundColor,
                              width: 2,
                            ),
                          ),
                        ),
                        tabs: const [
                          Tab(text: 'Background'),
                          Tab(text: 'Widget'),
                          Tab(text: 'About'),
                        ],
                        onTap: (index) => store.setTabIndex(index),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                      physics: const BouncingScrollPhysics(),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.fastOutSlowIn,
                        alignment: Alignment.topCenter,
                        child: CustomObserver(
                          name: 'SettingsPanelContent',
                          builder: (context) {
                            switch (store.currentTabIndex) {
                              case 0:
                                return const BackgroundSettingsView();
                              case 1:
                                return const WidgetSettings();
                              case 2:
                                return const About();
                              default:
                                return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BackgroundDismissible extends StatelessWidget {
  const _BackgroundDismissible();

  @override
  Widget build(BuildContext context) {
    final store = context.read<HomeStore>();
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => store.hidePanel(),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  static const Map<String, String> options = {
    'changelog': "See what's new",
    'liked_backgrounds': 'View liked photos',
    'donate': 'Donate',
    'sponsor': 'Become a sponsor',
    'report': 'Report an issue',
    'reset': 'Reset to default',
  };

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Theme.of(context).primaryColor,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: CustomDropdownButton<MapEntry<String, String>>(
          items: options.entries.toList(),
          underline: const SizedBox.shrink(),
          dropdownWidth: 200,
          dropdownDirection: DropdownDirection.left,
          dropdownOverButton: false,
          scrollbarThickness: 4,
          focusColor: Theme.of(context).primaryColor,
          dropdownElevation: 2,
          // dropdownPadding: EdgeInsets.zero,
          itemHeight: 32,
          onChanged: (value) {
            if (value == null) return;
            onSelected(context, value.key);
          },
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.dropdownOverlayColor,
          ),
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w400,
                height: 1,
              ),
          itemBuilder: (context, item) =>
              CustomDropdownMenuItem<MapEntry<String, String>>(
            value: item,
            hoverBackgroundColor: item.key == 'reset' ? Colors.red : null,
            hoverTextColor: item.key == 'reset' ? Colors.white : null,
            textColor: item.key == 'reset' ? Colors.red : null,
            child: Text(item.value),
          ),
          childBuilder: (ctx, item, onTap) => Theme(
            data: Theme.of(context),
            child: IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.more_vert_rounded),
              iconSize: 18,
              splashRadius: 16,
            ),
          ),
        ),
      ),
    );
  }

  void onSelected(BuildContext context, String value) {
    switch (value) {
      case 'changelog':
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => const ChangelogDialog(),
        );
        break;
      case 'liked_backgrounds':
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => LikedBackgroundsDialog(
            store: context.read<BackgroundStore>(),
          ),
        );
        break;
      case 'reset':
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => ResetDialog(
            onReset: () => onReset(context),
          ),
        );
        break;
      case 'report':
        launchUrl(Uri.parse(
            'https://github.com/birjuvachhani/pluto/issues/new/choose'));
        break;
      case 'donate':
        launchUrl(Uri.parse('https://www.buymeacoffee.com/birjuvachhani'));
        break;
      case 'sponsor':
        launchUrl(Uri.parse('https://github.com/sponsors/BirjuVachhani'));
        break;
    }
  }

  void onReset(BuildContext context) async {
    final BackgroundStore backgroundStore = context.read<BackgroundStore>();
    final HomeStore homeStore = context.read<HomeStore>();
    final WidgetStore widgetStore = context.read<WidgetStore>();
    await GetIt.instance
        .get<LocalStorageManager>()
        .clear(except: [StorageKeys.version]);
    homeStore.reset();
    backgroundStore.reset();
    widgetStore.reset();
  }
}

class ResetDialog extends StatelessWidget {
  final VoidCallback onReset;

  const ResetDialog({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: min(500, MediaQuery.of(context).size.width * 0.9),
        // height: min(500, MediaQuery.of(context).size.height * 0.9),
        padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
        decoration: BoxDecoration(
          color: AppColors.settingsPanelBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.restore_rounded,
                    size: 72,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reset to default settings?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Are you sure you want to reset all settings to default? This cannot be reversed.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.red.withOpacity(0.1),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Colors.red,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Note that this will also clear your liked photos!',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade900,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 14),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onReset();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Yes, Reset!'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
