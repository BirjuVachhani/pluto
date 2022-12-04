import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../model/background_settings.dart';
import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../model/unsplash_collection.dart';
import '../resources/storage_keys.dart';
import '../utils/storage_manager.dart';
import '../utils/utils.dart';

/// Most important model of all. This model is responsible for the background
/// of the home screen. It is responsible for loading the background image
/// from the internet, cache it, manage it, and for storing the settings of
/// the background.
abstract class BackgroundModelBase
    with ChangeNotifier, LazyInitializationMixin {
  late BackgroundSettings settings;

  /// Defines the size of the window. This is used to fetch images of the
  /// correct size.
  late Size windowSize;

  bool isLoadingImage = false;

  bool showLoadingBackground = false;

  /// In memory copy of the cached images.
  Uint8List? image1;
  Uint8List? image2;

  late Future initializationFuture;

  BackgroundMode get mode => settings.mode;

  FlatColor get color => settings.color;

  ColorGradient get gradient => settings.gradient;

  double get tint => settings.tint;

  bool get texture => settings.texture;

  bool get invert => settings.invert;

  ImageSource get imageSource => settings.source;

  UnsplashSource get unsplashSource => settings.unsplashSource;

  ImageRefreshRate get imageRefreshRate => settings.imageRefreshRate;

  int get imageIndex => settings.imageIndex;

  void setMode(BackgroundMode mode);

  void setColor(FlatColor color);

  void setGradient(ColorGradient gradient);

  void setTint(double tint);

  void setTexture(bool texture);

  void setInvert(bool invert);

  void setImageSource(ImageSource source);

  void setUnsplashSource(UnsplashSource source);

  void setImageRefreshRate(ImageRefreshRate rate);

  Color getForegroundColor();

  Future<void> changeBackground({bool updateAll = false});

  Uint8List? getImage();

  void onTimerCallback();
}

class BackgroundModel extends BackgroundModelBase {
  late final LocalStorageManager storage =
      GetIt.instance.get<LocalStorageManager>();

  /// Latest background change time.
  late DateTime backgroundLastUpdated;

  BackgroundModel() {
    initializationFuture = init();
  }

  @override
  Future<void> init() async {
    final data = await storage.getJson(StorageKeys.backgroundSettings);
    settings =
        data != null ? BackgroundSettings.fromJson(data) : BackgroundSettings();

    // load image last updated time
    backgroundLastUpdated =
        await storage.getInt(StorageKeys.backgroundLastUpdated).then((value) {
      if (value == null) return DateTime.now();
      return DateTime.fromMillisecondsSinceEpoch(value);
    });

    // Initialize image data
    initializeImages();

    initialized = true;
    notifyListeners();
  }

  /// Initializes images based on the current settings.
  /// We maintain 2 cached images at any time so that the user don't have to
  /// wait for it to load when they open new tab(Only applies if refresh rate is
  /// set to new tab).
  Future<void> initializeImages() async {
    if (imageSource == ImageSource.unsplash) {
      if (!await storage.containsKey(StorageKeys.image1)) {
        // If no images are cached, fetch new ones now and cache them.
        _loadUnsplashImage().then((value) {
          if (value == null) return;
          image1 = value;
          storage.setBase64(StorageKeys.image1, value);
        });
      } else {
        // If images are cached, load them.
        image1 = await storage.getBase64(StorageKeys.image1);
      }
      if (!await storage.containsKey(StorageKeys.image2)) {
        // If no images are cached, fetch new ones now and cache them.
        _loadUnsplashImage().then((value) {
          if (value == null) return;
          image2 = value;
          storage.setBase64(StorageKeys.image2, value);
        });
      } else {
        // If images are cached, load them.
        image2 = await storage.getBase64(StorageKeys.image2);
      }
    } else if (imageSource == ImageSource.local) {
      // TODO: support local images | load local images
    }

    if (imageRefreshRate == ImageRefreshRate.newTab) {
      // If the refresh rate is set to new tab, then we update the image index
      // and schedule a new image fetch for the next time so we already have
      // an image cached when the user opens a new tab again.
      // Fetch new images
      log('fetch new images for new tab type');
      _refetchAndCacheOtherImage();
      // toggle the index and save it.
      settings = settings.copyWith(imageIndex: imageIndex == 0 ? 1 : 0);
      _save();
    }

    _logNextBackgroundChange();
    notifyListeners();
  }

  /// Responsible for fetching and caching the image other than the current
  /// image.
  Future<void> _refetchAndCacheOtherImage() async {
    log('refetchAndCacheOtherImage');
    _loadUnsplashImage().then((value) {
      if (value == null) return;
      // We only update the image that is not currently being used so it can
      // be used next time when the user opens a new tab.
      if (imageIndex == 0) {
        image2 = value;
        storage.setBase64(StorageKeys.image2, value);
      } else {
        image1 = value;
        storage.setBase64(StorageKeys.image1, value);
      }
    });
    notifyListeners();
  }

  /// Logs the next background change time.
  void _logNextBackgroundChange() {
    if (!imageRefreshRate.requiresTimer) return;

    final nextUpdateTime = backgroundLastUpdated.add(imageRefreshRate.duration);

    // ignore: avoid_print
    print('Next Background change at $nextUpdateTime');
  }

  /// Fetches a new image from unsplash and sets it as the current image.
  /// If [updateAll] is set then it will also update the other cached image.
  /// This is helpful when the user changes the source of the image.
  @override
  Future<void> changeBackground({bool updateAll = false}) async {
    if (isLoadingImage) return;

    await _loadUnsplashImage(showLoadingBackground: true).then((value) {
      if (value == null) return;

      // Update last updated time to current time.
      backgroundLastUpdated = DateTime.now();
      // save updated time to storage
      storage.setInt(StorageKeys.backgroundLastUpdated,
          backgroundLastUpdated.millisecondsSinceEpoch);

      // Log next background change time.
      _logNextBackgroundChange();

      // Update the current image and cache it.
      if (imageIndex == 0) {
        image1 = value;
        storage.setBase64(StorageKeys.image1, value);
      } else {
        image2 = value;
        storage.setBase64(StorageKeys.image2, value);
      }
    });
    if (updateAll) {
      // Most probably the image source changed, so we need to update the other
      // cached image as well.
      await _loadUnsplashImage().then((value) {
        if (value == null) return;
        // Update the other image(not current one) and cache it.
        if (imageIndex == 0) {
          image2 = value;
          storage.setBase64(StorageKeys.image2, value);
        } else {
          image1 = value;
          storage.setBase64(StorageKeys.image1, value);
        }
      });
    }
  }

  /// Saves the current settings to storage.
  Future<bool> _save() =>
      storage.setJson(StorageKeys.backgroundSettings, settings.toJson());

  @override
  void setMode(BackgroundMode mode) {
    // Auto set some tint when image mode is selected.
    final tint = mode.isImage ? 17.0 : settings.tint;
    settings = settings.copyWith(mode: mode, tint: tint);
    _save();
    notifyListeners();
  }

  @override
  void setColor(FlatColor color) {
    settings = settings.copyWith(color: color);
    _save();
    notifyListeners();
  }

  @override
  void setGradient(ColorGradient gradient) {
    settings = settings.copyWith(gradient: gradient);
    _save();
    notifyListeners();
  }

  @override
  void setTint(double tint) {
    settings = settings.copyWith(tint: tint);
    _save();
    notifyListeners();
  }

  @override
  void setTexture(bool texture) {
    settings = settings.copyWith(texture: texture);
    _save();
    notifyListeners();
  }

  /// This would invert the current tint color and the foreground color.
  @override
  void setInvert(bool invert) {
    settings = settings.copyWith(invert: invert);
    _save();
    notifyListeners();
  }

  @override
  void setImageSource(ImageSource source) {
    settings = settings.copyWith(source: source);
    _save();
    notifyListeners();
  }

  @override
  void setUnsplashSource(UnsplashSource source) {
    settings = settings.copyWith(unsplashSource: source);
    _save();
    // Update the current image to the new source.
    changeBackground(updateAll: true);
    notifyListeners();
  }

  @override
  void setImageRefreshRate(ImageRefreshRate rate) {
    settings = settings.copyWith(imageRefreshRate: rate);
    _save();
    notifyListeners();
  }

  /// Retrieves the foreground color based on the current settings.
  @override
  Color getForegroundColor() {
    if (mode.isColor) return color.foreground;
    if (mode.isGradient) return gradient.foreground;
    // Return black(inverted) foreground color for image mode when
    // invert is true.
    if (invert) return Colors.black;
    // This is the default foreground color for images.
    return Colors.white;
  }

  /// Retrieves the current image bytes based on the current settings.
  @override
  Uint8List? getImage() {
    if (!mode.isImage) return null;
    final imageBytes = imageIndex == 0 ? image1 : image2;
    return imageBytes;
  }

  /// Responsible for fetching a new image from unsplash.
  /// [showLoadingBackground] param is used to show a loading
  /// background (grey scale) while the image is being fetched when true.
  /// Setting [isLoadingImage] to true will only show a loading indicator in
  /// the bottom of the page.
  Future<Uint8List?> _loadUnsplashImage({
    bool showLoadingBackground = false,
  }) async {
    log('loadUnsplashImage');
    isLoadingImage = true;
    // This means that only show loading image background(grey scale) when
    // explicitly told to.
    this.showLoadingBackground = showLoadingBackground;
    notifyListeners();

    try {
      // Fetch the image from unsplash.
      final http.Response response =
          await http.get(Uri.parse(_getUnsplashImageURL()));
      isLoadingImage = false;
      this.showLoadingBackground = false;
      notifyListeners();

      if (response.statusCode == 200) {
        log('loadUnsplashImage success');
        // Return the image bytes.
        return response.bodyBytes;
      }
      log('loadUnsplashImage failed ${response.statusCode}');
      // Received some error.
      log('Error: ${response.body}');
      return null;
    } catch (error, stacktrace) {
      log(error.toString());
      log(stacktrace.toString());
      // Some error occurred. Set loading to false.
      isLoadingImage = false;
      this.showLoadingBackground = false;
      notifyListeners();
      return null;
    }
  }

  /// Constructs an image URL of Unsplash based on the current settings.
  String _getUnsplashImageURL() {
    return 'https://source.unsplash.com${unsplashSource.getPath()}/${windowSize.width.toInt()}x${windowSize.height.toInt()}';
  }

  /// Refreshes the background image on timer callback.
  @override
  void onTimerCallback() async {
    if (!imageRefreshRate.requiresTimer) return;

    // log('Auto Background refresh has been triggered');
    // Exit if it is not time to change the background based on the user
    // settings.
    if (backgroundLastUpdated
            .add(imageRefreshRate.duration)
            .isAfter(DateTime.now()) ||
        isLoadingImage) {
      // Enable this to see the remaining time in console.

      // final remainingTime = backgroundLastUpdated
      //     .add(imageRefreshRate.duration)
      //     .difference(DateTime.now());
      // log('Next background update in ${remainingTime.inSeconds} seconds');
      return;
    }

    backgroundLastUpdated = DateTime.now();

    // Update the background image.
    storage.setInt(StorageKeys.backgroundLastUpdated,
        backgroundLastUpdated.millisecondsSinceEpoch);

    // Toggle the image index.
    settings = settings.copyWith(imageIndex: imageIndex == 0 ? 1 : 0);
    _save();

    // Log next background change time.
    _logNextBackgroundChange();

    await _refetchAndCacheOtherImage();
  }
}
