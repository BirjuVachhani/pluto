// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$_isPanelVisibleAtom =
      Atom(name: '_HomeStore._isPanelVisible', context: context);

  bool get isPanelVisible {
    _$_isPanelVisibleAtom.reportRead();
    return super._isPanelVisible;
  }

  @override
  bool get _isPanelVisible => isPanelVisible;

  @override
  set _isPanelVisible(bool value) {
    _$_isPanelVisibleAtom.reportWrite(value, super._isPanelVisible, () {
      super._isPanelVisible = value;
    });
  }

  late final _$_initializedAtom =
      Atom(name: '_HomeStore._initialized', context: context);

  bool get initialized {
    _$_initializedAtom.reportRead();
    return super._initialized;
  }

  @override
  bool get _initialized => initialized;

  @override
  set _initialized(bool value) {
    _$_initializedAtom.reportWrite(value, super._initialized, () {
      super._initialized = value;
    });
  }

  late final _$_currentTabIndexAtom =
      Atom(name: '_HomeStore._currentTabIndex', context: context);

  int get currentTabIndex {
    _$_currentTabIndexAtom.reportRead();
    return super._currentTabIndex;
  }

  @override
  int get _currentTabIndex => currentTabIndex;

  @override
  set _currentTabIndex(int value) {
    _$_currentTabIndexAtom.reportWrite(value, super._currentTabIndex, () {
      super._currentTabIndex = value;
    });
  }

  late final _$resetAsyncAction =
      AsyncAction('_HomeStore.reset', context: context);

  @override
  Future<void> reset() {
    return _$resetAsyncAction.run(() => super.reset());
  }

  late final _$_HomeStoreActionController =
      ActionController(name: '_HomeStore', context: context);

  @override
  void showPanel() {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.showPanel');
    try {
      return super.showPanel();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void hidePanel() {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.hidePanel');
    try {
      return super.hidePanel();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTabIndex(int index) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.setTabIndex');
    try {
      return super.setTabIndex(index);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
