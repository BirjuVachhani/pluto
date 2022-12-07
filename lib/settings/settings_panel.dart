import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import 'about.dart';
import 'background_settings_view.dart';
import 'widget_settings.dart';

class SettingsPanel extends StatefulWidget {
  const SettingsPanel({super.key});

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeModelBase>(builder: (context, model, child) {
      if (!model.initialized || !model.isPanelVisible) {
        return const SizedBox.shrink();
      }
      return Stack(
        fit: StackFit.expand,
        children: [
          const _BackgroundDismissible(),
          Positioned(
            top: 32,
            right: 32,
            bottom: 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    width: 360,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                    child: AnimatedSize(
                      alignment: Alignment.topCenter,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
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
                              const Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0.5,
                                child: Divider(height: 1, thickness: 1),
                              ),
                              SizedBox(
                                width: 360,
                                child: TabBar(
                                  controller: tabController,
                                  unselectedLabelColor: Colors.black,
                                  labelColor: Colors.black,
                                  isScrollable: true,
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  indicator: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                        width: 1,
                                      ),
                                      left: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                        width: 1,
                                      ),
                                      bottom: const BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  tabs: const [
                                    Tab(text: 'Background'),
                                    Tab(text: 'Widget'),
                                    Tab(text: 'About'),
                                  ],
                                  onTap: (index) =>
                                      setState(() => currentTabIndex = index),
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                              child: Builder(builder: (context) {
                                if (currentTabIndex == 0) {
                                  return const BackgroundSettingsView();
                                }
                                if (currentTabIndex == 1) {
                                  return const WidgetSettings();
                                }
                                if (currentTabIndex == 2) return const About();

                                return const SizedBox.shrink();
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
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
