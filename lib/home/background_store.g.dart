// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BackgroundStore on _BackgroundStore, Store {
  Computed<bool>? _$isLikedComputed;

  @override
  bool get isLiked => (_$isLikedComputed ??=
          Computed<bool>(() => super.isLiked, name: '_BackgroundStore.isLiked'))
      .value;
  Computed<bool>? _$isColorModeComputed;

  @override
  bool get isColorMode =>
      (_$isColorModeComputed ??= Computed<bool>(() => super.isColorMode,
              name: '_BackgroundStore.isColorMode'))
          .value;
  Computed<bool>? _$isGradientModeComputed;

  @override
  bool get isGradientMode =>
      (_$isGradientModeComputed ??= Computed<bool>(() => super.isGradientMode,
              name: '_BackgroundStore.isGradientMode'))
          .value;
  Computed<bool>? _$isImageModeComputed;

  @override
  bool get isImageMode =>
      (_$isImageModeComputed ??= Computed<bool>(() => super.isImageMode,
              name: '_BackgroundStore.isImageMode'))
          .value;
  Computed<Color>? _$foregroundColorComputed;

  @override
  Color get foregroundColor => (_$foregroundColorComputed ??= Computed<Color>(
          () => super.foregroundColor,
          name: '_BackgroundStore.foregroundColor'))
      .value;
  Computed<Background?>? _$currentImageComputed;

  @override
  Background? get currentImage => (_$currentImageComputed ??=
          Computed<Background?>(() => super.currentImage,
              name: '_BackgroundStore.currentImage'))
      .value;

  late final _$_isLoadingImageAtom =
      Atom(name: '_BackgroundStore._isLoadingImage', context: context);

  bool get isLoadingImage {
    _$_isLoadingImageAtom.reportRead();
    return super._isLoadingImage;
  }

  @override
  bool get _isLoadingImage => isLoadingImage;

  @override
  set _isLoadingImage(bool value) {
    _$_isLoadingImageAtom.reportWrite(value, super._isLoadingImage, () {
      super._isLoadingImage = value;
    });
  }

  late final _$_showLoadingBackgroundAtom =
      Atom(name: '_BackgroundStore._showLoadingBackground', context: context);

  bool get showLoadingBackground {
    _$_showLoadingBackgroundAtom.reportRead();
    return super._showLoadingBackground;
  }

  @override
  bool get _showLoadingBackground => showLoadingBackground;

  @override
  set _showLoadingBackground(bool value) {
    _$_showLoadingBackgroundAtom
        .reportWrite(value, super._showLoadingBackground, () {
      super._showLoadingBackground = value;
    });
  }

  late final _$_initializedAtom =
      Atom(name: '_BackgroundStore._initialized', context: context);

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

  late final _$_image1Atom =
      Atom(name: '_BackgroundStore._image1', context: context);

  Background? get image1 {
    _$_image1Atom.reportRead();
    return super._image1;
  }

  @override
  Background? get _image1 => image1;

  @override
  set _image1(Background? value) {
    _$_image1Atom.reportWrite(value, super._image1, () {
      super._image1 = value;
    });
  }

  late final _$_image2Atom =
      Atom(name: '_BackgroundStore._image2', context: context);

  Background? get image2 {
    _$_image2Atom.reportRead();
    return super._image2;
  }

  @override
  Background? get _image2 => image2;

  @override
  set _image2(Background? value) {
    _$_image2Atom.reportWrite(value, super._image2, () {
      super._image2 = value;
    });
  }

  late final _$_likedBackgroundsAtom =
      Atom(name: '_BackgroundStore._likedBackgrounds', context: context);

  ObservableMap<String, LikedBackground> get likedBackgrounds {
    _$_likedBackgroundsAtom.reportRead();
    return super._likedBackgrounds;
  }

  @override
  ObservableMap<String, LikedBackground> get _likedBackgrounds =>
      likedBackgrounds;

  @override
  set _likedBackgrounds(ObservableMap<String, LikedBackground> value) {
    _$_likedBackgroundsAtom.reportWrite(value, super._likedBackgrounds, () {
      super._likedBackgrounds = value;
    });
  }

  late final _$_modeAtom =
      Atom(name: '_BackgroundStore._mode', context: context);

  BackgroundMode get mode {
    _$_modeAtom.reportRead();
    return super._mode;
  }

  @override
  BackgroundMode get _mode => mode;

  @override
  set _mode(BackgroundMode value) {
    _$_modeAtom.reportWrite(value, super._mode, () {
      super._mode = value;
    });
  }

  late final _$_colorAtom =
      Atom(name: '_BackgroundStore._color', context: context);

  FlatColor get color {
    _$_colorAtom.reportRead();
    return super._color;
  }

  @override
  FlatColor get _color => color;

  @override
  set _color(FlatColor value) {
    _$_colorAtom.reportWrite(value, super._color, () {
      super._color = value;
    });
  }

  late final _$_gradientAtom =
      Atom(name: '_BackgroundStore._gradient', context: context);

  ColorGradient get gradient {
    _$_gradientAtom.reportRead();
    return super._gradient;
  }

  @override
  ColorGradient get _gradient => gradient;

  @override
  set _gradient(ColorGradient value) {
    _$_gradientAtom.reportWrite(value, super._gradient, () {
      super._gradient = value;
    });
  }

  late final _$_tintAtom =
      Atom(name: '_BackgroundStore._tint', context: context);

  double get tint {
    _$_tintAtom.reportRead();
    return super._tint;
  }

  @override
  double get _tint => tint;

  @override
  set _tint(double value) {
    _$_tintAtom.reportWrite(value, super._tint, () {
      super._tint = value;
    });
  }

  late final _$_textureAtom =
      Atom(name: '_BackgroundStore._texture', context: context);

  bool get texture {
    _$_textureAtom.reportRead();
    return super._texture;
  }

  @override
  bool get _texture => texture;

  @override
  set _texture(bool value) {
    _$_textureAtom.reportWrite(value, super._texture, () {
      super._texture = value;
    });
  }

  late final _$_invertAtom =
      Atom(name: '_BackgroundStore._invert', context: context);

  bool get invert {
    _$_invertAtom.reportRead();
    return super._invert;
  }

  @override
  bool get _invert => invert;

  @override
  set _invert(bool value) {
    _$_invertAtom.reportWrite(value, super._invert, () {
      super._invert = value;
    });
  }

  late final _$_greyScaleAtom =
      Atom(name: '_BackgroundStore._greyScale', context: context);

  bool get greyScale {
    _$_greyScaleAtom.reportRead();
    return super._greyScale;
  }

  @override
  bool get _greyScale => greyScale;

  @override
  set _greyScale(bool value) {
    _$_greyScaleAtom.reportWrite(value, super._greyScale, () {
      super._greyScale = value;
    });
  }

  late final _$_imageSourceAtom =
      Atom(name: '_BackgroundStore._imageSource', context: context);

  ImageSource get imageSource {
    _$_imageSourceAtom.reportRead();
    return super._imageSource;
  }

  @override
  ImageSource get _imageSource => imageSource;

  @override
  set _imageSource(ImageSource value) {
    _$_imageSourceAtom.reportWrite(value, super._imageSource, () {
      super._imageSource = value;
    });
  }

  late final _$_unsplashSourceAtom =
      Atom(name: '_BackgroundStore._unsplashSource', context: context);

  UnsplashSource get unsplashSource {
    _$_unsplashSourceAtom.reportRead();
    return super._unsplashSource;
  }

  @override
  UnsplashSource get _unsplashSource => unsplashSource;

  @override
  set _unsplashSource(UnsplashSource value) {
    _$_unsplashSourceAtom.reportWrite(value, super._unsplashSource, () {
      super._unsplashSource = value;
    });
  }

  late final _$_backgroundRefreshRateAtom =
      Atom(name: '_BackgroundStore._backgroundRefreshRate', context: context);

  BackgroundRefreshRate get backgroundRefreshRate {
    _$_backgroundRefreshRateAtom.reportRead();
    return super._backgroundRefreshRate;
  }

  @override
  BackgroundRefreshRate get _backgroundRefreshRate => backgroundRefreshRate;

  @override
  set _backgroundRefreshRate(BackgroundRefreshRate value) {
    _$_backgroundRefreshRateAtom
        .reportWrite(value, super._backgroundRefreshRate, () {
      super._backgroundRefreshRate = value;
    });
  }

  late final _$_imageIndexAtom =
      Atom(name: '_BackgroundStore._imageIndex', context: context);

  int get imageIndex {
    _$_imageIndexAtom.reportRead();
    return super._imageIndex;
  }

  @override
  int get _imageIndex => imageIndex;

  @override
  set _imageIndex(int value) {
    _$_imageIndexAtom.reportWrite(value, super._imageIndex, () {
      super._imageIndex = value;
    });
  }

  late final _$_image1TimeAtom =
      Atom(name: '_BackgroundStore._image1Time', context: context);

  DateTime get image1Time {
    _$_image1TimeAtom.reportRead();
    return super._image1Time;
  }

  @override
  DateTime get _image1Time => image1Time;

  @override
  set _image1Time(DateTime value) {
    _$_image1TimeAtom.reportWrite(value, super._image1Time, () {
      super._image1Time = value;
    });
  }

  late final _$_image2TimeAtom =
      Atom(name: '_BackgroundStore._image2Time', context: context);

  DateTime get image2Time {
    _$_image2TimeAtom.reportRead();
    return super._image2Time;
  }

  @override
  DateTime get _image2Time => image2Time;

  @override
  set _image2Time(DateTime value) {
    _$_image2TimeAtom.reportWrite(value, super._image2Time, () {
      super._image2Time = value;
    });
  }

  late final _$_imageResolutionAtom =
      Atom(name: '_BackgroundStore._imageResolution', context: context);

  ImageResolution get imageResolution {
    _$_imageResolutionAtom.reportRead();
    return super._imageResolution;
  }

  @override
  ImageResolution get _imageResolution => imageResolution;

  @override
  set _imageResolution(ImageResolution value) {
    _$_imageResolutionAtom.reportWrite(value, super._imageResolution, () {
      super._imageResolution = value;
    });
  }

  late final _$_customSourcesAtom =
      Atom(name: '_BackgroundStore._customSources', context: context);

  ObservableList<UnsplashSource> get customSources {
    _$_customSourcesAtom.reportRead();
    return super._customSources;
  }

  @override
  ObservableList<UnsplashSource> get _customSources => customSources;

  @override
  set _customSources(ObservableList<UnsplashSource> value) {
    _$_customSourcesAtom.reportWrite(value, super._customSources, () {
      super._customSources = value;
    });
  }

  late final _$initializeImagesAsyncAction =
      AsyncAction('_BackgroundStore.initializeImages', context: context);

  @override
  Future<void> initializeImages() {
    return _$initializeImagesAsyncAction.run(() => super.initializeImages());
  }

  late final _$_refetchAndCacheOtherImageAsyncAction = AsyncAction(
      '_BackgroundStore._refetchAndCacheOtherImage',
      context: context);

  @override
  Future<void> _refetchAndCacheOtherImage() {
    return _$_refetchAndCacheOtherImageAsyncAction
        .run(() => super._refetchAndCacheOtherImage());
  }

  late final _$onChangeBackgroundAsyncAction =
      AsyncAction('_BackgroundStore.onChangeBackground', context: context);

  @override
  Future<void> onChangeBackground({bool updateAll = false}) {
    return _$onChangeBackgroundAsyncAction
        .run(() => super.onChangeBackground(updateAll: updateAll));
  }

  late final _$_loadImageFromSourceAsyncAction =
      AsyncAction('_BackgroundStore._loadImageFromSource', context: context);

  @override
  Future<Background?> _loadImageFromSource(
      {bool showLoadingBackground = false}) {
    return _$_loadImageFromSourceAsyncAction.run(() => super
        ._loadImageFromSource(showLoadingBackground: showLoadingBackground));
  }

  late final _$onTimerCallbackAsyncAction =
      AsyncAction('_BackgroundStore.onTimerCallback', context: context);

  @override
  Future<void> onTimerCallback() {
    return _$onTimerCallbackAsyncAction.run(() => super.onTimerCallback());
  }

  late final _$onToggleLikeAsyncAction =
      AsyncAction('_BackgroundStore.onToggleLike', context: context);

  @override
  Future<void> onToggleLike(bool liked) {
    return _$onToggleLikeAsyncAction.run(() => super.onToggleLike(liked));
  }

  late final _$resetAsyncAction =
      AsyncAction('_BackgroundStore.reset', context: context);

  @override
  Future<void> reset({bool clear = true}) {
    return _$resetAsyncAction.run(() => super.reset(clear: clear));
  }

  late final _$removeLikedPhotoAsyncAction =
      AsyncAction('_BackgroundStore.removeLikedPhoto', context: context);

  @override
  Future<void> removeLikedPhoto(String key) {
    return _$removeLikedPhotoAsyncAction.run(() => super.removeLikedPhoto(key));
  }

  late final _$_BackgroundStoreActionController =
      ActionController(name: '_BackgroundStore', context: context);

  @override
  void updateBackground() {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.updateBackground');
    try {
      return super.updateBackground();
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMode(BackgroundMode mode) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setMode');
    try {
      return super.setMode(mode);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setColor(FlatColor color) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setColor');
    try {
      return super.setColor(color);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setGradient(ColorGradient gradient) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setGradient');
    try {
      return super.setGradient(gradient);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTint(double tint) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setTint');
    try {
      return super.setTint(tint);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTexture(bool texture) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setTexture');
    try {
      return super.setTexture(texture);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInvert(bool invert) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setInvert');
    try {
      return super.setInvert(invert);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setImageSource(ImageSource source) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setImageSource');
    try {
      return super.setImageSource(source);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUnsplashSource(UnsplashSource source) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setUnsplashSource');
    try {
      return super.setUnsplashSource(source);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setImageRefreshRate(BackgroundRefreshRate rate) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setImageRefreshRate');
    try {
      return super.setImageRefreshRate(rate);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setImageResolution(ImageResolution resolution) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setImageResolution');
    try {
      return super.setImageResolution(resolution);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setGreyScale(bool greyScale) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.setGreyScale');
    try {
      return super.setGreyScale(greyScale);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addNewCollection(UnsplashSource source, {bool setAsCurrent = false}) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.addNewCollection');
    try {
      return super.addNewCollection(source, setAsCurrent: setAsCurrent);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCustomCollection(UnsplashSource source) {
    final _$actionInfo = _$_BackgroundStoreActionController.startAction(
        name: '_BackgroundStore.removeCustomCollection');
    try {
      return super.removeCustomCollection(source);
    } finally {
      _$_BackgroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLiked: ${isLiked},
isColorMode: ${isColorMode},
isGradientMode: ${isGradientMode},
isImageMode: ${isImageMode},
foregroundColor: ${foregroundColor},
currentImage: ${currentImage}
    ''';
  }
}
