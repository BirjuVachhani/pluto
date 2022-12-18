import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '../resources/colors.dart';
import 'about.dart';
import 'background_settings_view.dart';
import 'changelog_dialog.dart';
import 'widget_settings.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeModelBase>(builder: (context, model, child) {
      if (!model.initialized || !model.isPanelVisible) {
        return const SizedBox.shrink();
      }
      return Stack(
        fit: StackFit.expand,
        children: const [
          _BackgroundDismissible(),
          Positioned(
            top: 32,
            right: 32,
            bottom: 32,
            child: SettingsPanelContent(),
          ),
        ],
      );
    });
  }
}

class SettingsPanelContent extends StatefulWidget {
  const SettingsPanelContent({super.key});

  @override
  State<SettingsPanelContent> createState() => _SettingsPanelContentState();
}

class _SettingsPanelContentState extends State<SettingsPanelContent>
    with SingleTickerProviderStateMixin {
  late final HomeModelBase model = context.read<HomeModelBase>();

  @override
  void initState() {
    super.initState();
    model.tabController = TabController(length: 3, vsync: this);
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
                          onPressed: () => model.hidePanel(),
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
                        controller: model.tabController,
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
                        onTap: (index) => model.currentTabIndex.value = index,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                      child: ValueListenableBuilder<int>(
                        valueListenable: model.currentTabIndex,
                        builder: (context, index, child) {
                          if (model.currentTabIndex.value == 0) {
                            return const BackgroundSettingsView();
                          }
                          if (model.currentTabIndex.value == 1) {
                            return const WidgetSettings();
                          }
                          if (model.currentTabIndex.value == 2) {
                            return const About();
                          }
                          return const SizedBox.shrink();
                        },
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
    final model = context.read<HomeModelBase>();
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => model.hidePanel(),
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
    'changelog': 'View Changelog',
    // 'liked_backgrounds': 'View liked',
  };

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Theme.of(context).primaryColor,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: PopupMenuButton(
          itemBuilder: (context) => [
            for (final option in options.entries)
              PopupMenuItem(
                value: option.key,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                height: 34,
                textStyle: const TextStyle(fontSize: 14),
                child: Text(option.value),
              ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          color: AppColors.dropdownOverlayColor,
          position: PopupMenuPosition.under,
          onSelected: (value) => onSelected(context, value),
          icon: const Icon(Icons.more_vert_rounded),
          iconSize: 18,
          splashRadius: 16,
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
        // TODO:
        break;
    }
  }
}
