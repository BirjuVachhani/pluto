import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../utils/utils.dart';

part 'home_store.g.dart';

// ignore: library_private_types_in_public_api
class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store, LazyInitializationMixin {
  _HomeStore() {
    init();
  }

  @readonly
  bool _isPanelVisible = false;

  @readonly
  bool _initialized = false;

  @readonly
  int _currentTabIndex = 0;

  TabController? tabController;

  @override
  Future<void> init() async {
    // Initialize stuff
    _initialized = true;
  }

  @action
  void showPanel() {
    _isPanelVisible = true;
  }

  @action
  void hidePanel() {
    _isPanelVisible = false;
    _currentTabIndex = 0;
  }

  @action
  Future<void> reset() async {
    _isPanelVisible = false;
    _initialized = false;
    _currentTabIndex = 0;
    await init();
  }

  @action
  void setTabIndex(int index) {
    _currentTabIndex = index;
  }

  void dispose() {
    tabController?.dispose();
  }
}
