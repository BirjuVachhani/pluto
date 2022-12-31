import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:screwdriver/screwdriver.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/background_settings.dart';
import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../model/unsplash_collection.dart';
import '../resources/color_gradients.dart';
import '../resources/flat_colors.dart';
import '../resources/storage_keys.dart';
import '../resources/unsplash_sources.dart';
import '../utils/extensions.dart';
import '../utils/storage_manager.dart';
import '../utils/universal/universal.dart';
import '../utils/utils.dart';

part 'background_model.g.dart';

/// Most important model of all. This model is responsible for the background
/// of the home screen. It is responsible for loading the background image
/// from the internet, cache it, manage it, and for storing the settings of
/// the background.
// ignore: library_private_types_in_public_api
class BackgroundStore = _BackgroundStore with _$BackgroundStore;

abstract class _BackgroundStore
    with Store, ChangeNotifier, LazyInitializationMixin {
  late final LocalStorageManager storage =
      GetIt.instance.get<LocalStorageManager>();

  // Defines the size of the window. This is used to fetch images of the
  /// correct size.
  Size windowSize = const Size(1920, 1080);

  @readonly
  bool _isLoadingImage = false;

  @readonly
  bool _showLoadingBackground = false;

  @readonly
  bool _initialized = false;

  /// In memory copy of the cached images.
  @readonly
  Background? _image1;

  @readonly
  Background? _image2;

  @readonly
  Map<String, LikedBackground> _likedBackgrounds = {};

  late Future initializationFuture;

  @readonly
  BackgroundMode _mode = BackgroundMode.color;

  @readonly
  FlatColor _color = FlatColors.minimal;

  @readonly
  ColorGradient _gradient = ColorGradients.youtube;

  @readonly
  double _tint = 0.0;

  @readonly
  bool _texture = false;

  @readonly
  bool _invert = false;

  @readonly
  bool _greyScale = false;

  @readonly
  ImageSource _imageSource = ImageSource.unsplash;

  @readonly
  UnsplashSource _unsplashSource = UnsplashSources.curated;

  @readonly
  ImageRefreshRate _imageRefreshRate = ImageRefreshRate.newTab;

  @readonly
  int _imageIndex = 0;

  @readonly
  ImageResolution _imageResolution = ImageResolution.auto;

  @computed
  bool get isLiked {
    return currentImage != null &&
        _likedBackgrounds
            .containsKey(StorageKeys.likedBackground(currentImage!.id));
  }

  @computed
  bool get isColorMode => _mode.isColor;

  @computed
  bool get isGradientMode => _mode.isGradient;

  @computed
  bool get isImageMode => _mode.isImage;

  /// Latest background change time.
  late DateTime backgroundLastUpdated;

  late final DeBouncer _debouncer = DeBouncer(const Duration(seconds: 1));

  _BackgroundStore() {
    initializationFuture = init();
  }

  @override
  Future<void> init() async {
    final data = await storage.getJson(StorageKeys.backgroundSettings);
    final settings =
        data != null ? BackgroundSettings.fromJson(data) : BackgroundSettings();

    _mode = settings.mode;
    _color = settings.color;
    _gradient = settings.gradient;
    _tint = settings.tint;
    _texture = settings.texture;
    _invert = settings.invert;
    _greyScale = settings.greyScale;
    _imageSource = settings.source;
    _unsplashSource = settings.unsplashSource;
    _imageRefreshRate = settings.imageRefreshRate;
    _imageResolution = settings.imageResolution;

    // load image last updated time
    _imageIndex = await storage.getInt(StorageKeys.imageIndex) ?? 0;
    backgroundLastUpdated =
        await storage.getInt(StorageKeys.backgroundLastUpdated).then((value) {
      if (value == null) return DateTime.now();
      return DateTime.fromMillisecondsSinceEpoch(value);
    });

    // Initialize image data
    initializeImages();

    _initialized = true;
  }

  /// Initializes images based on the current settings.
  /// We maintain 2 cached images at any time so that the user don't have to
  /// wait for it to load when they open new tab(Only applies if refresh rate is
  /// set to new tab).
  @action
  Future<void> initializeImages() async {
    if (_imageSource == ImageSource.unsplash ||
        _imageSource == ImageSource.userLikes) {
      if (!await storage.containsKey(StorageKeys.image1)) {
        // If no images are cached, fetch new ones now and cache them.
        _loadImageFromSource().then((result) {
          if (result == null) return;
          _image1 = result;
          storage.setJson(StorageKeys.image1, result.toJson());
        });
      } else {
        // If images are cached, load them.
        _image1 = await storage.getSerializableObject(
            StorageKeys.image1, Background.fromJson);
      }
      if (!await storage.containsKey(StorageKeys.image2)) {
        // If no images are cached, fetch new ones now and cache them.
        _loadImageFromSource().then((result) {
          if (result == null) return;
          _image2 = result;
          storage.setJson(StorageKeys.image2, result.toJson());
        });
      } else {
        // If images are cached, load them.
        _image2 = await storage.getSerializableObject(
            StorageKeys.image2, Background.fromJson);
      }
      final future = _loadLikedBackgrounds();
      if (_imageSource == ImageSource.userLikes) {
        // If the user likes are the source, we need to wait for the liked
        // backgrounds to load before we can load the image.
        log('Waiting for liked backgrounds to load');
        await future;
      }
    } else if (_imageSource == ImageSource.local) {
      // TODO: support local images | load local images
    }

    if (_imageRefreshRate == ImageRefreshRate.newTab) {
      // If the refresh rate is set to new tab, then we update the image index
      // and schedule a new image fetch for the next time so we already have
      // an image cached when the user opens a new tab again.
      // Fetch new images
      log('fetch new images for new tab type');
      _refetchAndCacheOtherImage();
      // toggle the index and save it.

      _imageIndex = _imageIndex == 0 ? 1 : 0;
      storage.setInt(StorageKeys.imageIndex, _imageIndex);
    }

    _logNextBackgroundChange();
  }

  /// Loads the liked backgrounds from the storage.
  Future<void> _loadLikedBackgrounds() async {
    final Set<String> keys = await storage.getKeys();
    final likedBackgrounds = <String, LikedBackground>{};
    for (final key in keys) {
      if (!key.startsWith(StorageKeys.liked)) continue;
      final background =
          await storage.getSerializableObject(key, LikedBackground.fromJson);
      if (background == null) continue;
      likedBackgrounds[key] = background;
    }
    log('Found ${likedBackgrounds.length} liked backgrounds');
    _likedBackgrounds = likedBackgrounds;
  }

  /// Responsible for fetching and caching the image other than the current
  /// image.
  @action
  Future<void> _refetchAndCacheOtherImage() async {
    log('refetchAndCacheOtherImage');
    _loadImageFromSource().then((result) {
      if (result == null) return;
      // We only update the image that is not currently being used so it can
      // be used next time when the user opens a new tab.
      if (_imageIndex == 0) {
        _image2 = result;
        storage.setJson(StorageKeys.image2, result.toJson());
      } else {
        _image1 = result;
        storage.setJson(StorageKeys.image1, result.toJson());
      }
    });
  }

  /// Logs the next background change time.
  void _logNextBackgroundChange() {
    if (!_imageRefreshRate.requiresTimer) return;

    final DateTime? nextUpdateTime =
        _imageRefreshRate.nextUpdateTime(backgroundLastUpdated);
    if (nextUpdateTime == null) return;

    // ignore: avoid_print
    print(
        'Next Background change at ${DateFormat('dd/MM/yyyy hh:mm:ss a').format(nextUpdateTime)}');
  }

  /// Fetches a new image from unsplash and sets it as the current image.
  /// If [updateAll] is set then it will also update the other cached image.
  /// This is helpful when the user changes the source of the image.
  @action
  Future<void> changeBackground({bool updateAll = false}) async {
    if (_isLoadingImage) return;

    await _loadImageFromSource(showLoadingBackground: true).then((result) {
      if (result == null) return;

      // Update last updated time to current time.
      backgroundLastUpdated = DateTime.now();
      // save updated time to storage
      storage.setInt(StorageKeys.backgroundLastUpdated,
          backgroundLastUpdated.millisecondsSinceEpoch);

      // Log next background change time.
      _logNextBackgroundChange();

      // Update the current image and cache it.
      if (_imageIndex == 0) {
        _image1 = result;
        storage.setJson(StorageKeys.image1, result.toJson());
      } else {
        _image2 = result;
        storage.setJson(StorageKeys.image2, result.toJson());
      }
    });
    if (updateAll) {
      // Most probably the image source changed, so we need to update the other
      // cached image as well.
      await _loadImageFromSource().then((result) {
        if (result == null) return;
        // Update the other image(not current one) and cache it.
        if (_imageIndex == 0) {
          _image2 = result;
          storage.setJson(StorageKeys.image2, result.toJson());
        } else {
          _image1 = result;
          storage.setJson(StorageKeys.image1, result.toJson());
        }
      });
    }
  }

  /// Saves the current settings to storage.
  Future<bool> _save() {
    final settings = BackgroundSettings(
      mode: _mode,
      color: _color,
      gradient: _gradient,
      source: _imageSource,
      tint: _tint,
      texture: _texture,
      invert: _invert,
      greyScale: _greyScale,
      imageRefreshRate: _imageRefreshRate,
      imageResolution: _imageResolution,
      unsplashSource: _unsplashSource,
    );
    return storage.setJson(StorageKeys.backgroundSettings, settings.toJson());
  }

  @action
  void setMode(BackgroundMode mode) {
    // Auto set some tint when image mode is selected.
    _mode = mode;
    _tint = mode.isImage ? 17 : 0;
    _save();
  }

  @action
  void setColor(FlatColor color) {
    _color = color;
    _save();
  }

  @action
  void setGradient(ColorGradient gradient) {
    _gradient = gradient;
    _save();
  }

  @action
  void setTint(double tint) {
    _tint = tint;
    _save();
  }

  @action
  void setTexture(bool texture) {
    _texture = texture;
    _save();
  }

  /// This would invert the current tint color and the foreground color.
  @action
  void setInvert(bool invert) {
    _invert = invert;
    _save();
  }

  @action
  void setImageSource(ImageSource source) {
    _imageSource = source;
    _save();
    // Update the current image to the new source.
    changeBackground(updateAll: true);
  }

  @action
  void setUnsplashSource(UnsplashSource source) {
    _unsplashSource = source;
    _save();
    // Update the current image to the new source.
    changeBackground(updateAll: true);
  }

  @action
  void setImageRefreshRate(ImageRefreshRate rate) {
    _imageRefreshRate = rate;
    _save();
  }

  @action
  void setImageResolution(ImageResolution resolution) {
    _imageResolution = resolution;
    _save();
    changeBackground(updateAll: true);
  }

  @action
  void setGreyScale(bool greyScale) {
    _greyScale = greyScale;
    _save();
  }

  /// Retrieves the foreground color based on the current settings.
  @computed
  Color get foregroundColor {
    if (_mode.isColor) return _color.foreground;
    if (_mode.isGradient) return _gradient.foreground;
    // Return black(inverted) foreground color for image mode when
    // invert is true.
    if (_invert) return Colors.black;
    // This is the default foreground color for images.
    return Colors.white;
  }

  /// Retrieves the current image bytes based on the current settings.
  @computed
  Background? get currentImage {
    if (!_mode.isImage) return null;
    final image = _imageIndex == 0 ? _image1 : _image2;
    return image;
  }

  /// This retrieves the original url for unsplash image as Unsplash source API
  /// redirects to the original image url.
  Future<String?> _getUrlLocation(String url) async {
    return getRedirectionUrl(url);
  }

  /// Responsible for fetching a new image from unsplash.
  /// [showLoadingBackground] param is used to show a loading
  /// background (grey scale) while the image is being fetched when true.
  /// Setting [_isLoadingImage] to true will only show a loading indicator in
  /// the bottom of the page.
  ///
  /// Returns a [MapEntry] where key is the original image URL and the value
  /// is the image bytes. The key will be an empty string if the original image
  /// URL could not be retrieved.
  ///
  /// Returns null if the image could not be fetched.
  @action
  Future<Background?> _loadImageFromSource({
    bool showLoadingBackground = false,
  }) async {
    log('loadImageFromSource');
    _isLoadingImage = true;
    // This means that only show loading image background(grey scale) when
    // explicitly told to.
    _showLoadingBackground = showLoadingBackground;

    try {
      // Fetch the image from unsplash.
      final String actualImageUrl = await _getImageUrlFromSource();
      log('actualUrl: $actualImageUrl');
      final http.Response response = await http.get(Uri.parse(actualImageUrl));
      _isLoadingImage = false;
      _showLoadingBackground = false;
      if (response.statusCode == 200) {
        log('loadUnsplashImage success');
        // Return the image bytes.
        // try {
        //   log('pre-caching downloaded image');
        //   if(context != null) {
        //     precacheImage(Image.memory(response.bodyBytes).image, context!);
        //   }
        // }catch(e){
        //   return response.bodyBytes;
        // }
        return Background(
          id: Uri.parse(actualImageUrl).pathSegments.last,
          url: actualImageUrl,
          bytes: response.bodyBytes,
        );
      }
      log('loadUnsplashImage failed ${response.statusCode}');
      // Received some error.
      log('Error: ${response.body}');
      return null;
    } catch (error, stacktrace) {
      log(error.toString());
      log(stacktrace.toString());
      // Some error occurred. Set loading to false.
      _isLoadingImage = false;
      _showLoadingBackground = false;
      return null;
    }
  }

  /// Constructs an image URL of Unsplash based on the current settings.
  String _buildUnsplashImageURL(UnsplashSource source) {
    final Size size = _imageResolution.toSize() ?? windowSize;
    return 'https://source.unsplash.com${source.getPath()}/${size.width.toInt()}x${size.height.toInt()}';
  }

  /// Refreshes the background image on timer callback.
  @action
  Future<void> onTimerCallback() async {
    if (!_imageRefreshRate.requiresTimer) return;

    // log('Auto Background refresh has been triggered');
    // Exit if it is not time to change the background based on the user
    // settings.
    if (_imageRefreshRate
            .nextUpdateTime(backgroundLastUpdated)!
            .isAfter(DateTime.now()) ||
        _isLoadingImage) {
      // Enable this to see the remaining time in console.

      // final remainingTime = backgroundLastUpdated
      //     .add(imageRefreshRate.duration)
      //     .difference(DateTime.now());
      // log('[DEBUG] Next background update in ${remainingTime.inSeconds} seconds');
      return;
    }

    backgroundLastUpdated = DateTime.now();

    // Update the background image.
    storage.setInt(StorageKeys.backgroundLastUpdated,
        backgroundLastUpdated.millisecondsSinceEpoch);

    // Toggle the image index.
    _imageIndex = _imageIndex == 0 ? 1 : 0;
    storage.setInt(StorageKeys.imageIndex, _imageIndex);

    // Log next background change time.
    _logNextBackgroundChange();

    await _refetchAndCacheOtherImage();
  }

  Future<void> onDownload() async {
    final Background? image = currentImage;
    if (image == null) return;

    final fileName =
        'background_${DateTime.now().millisecondsSinceEpoch ~/ 1000}.jpg';

    if (kIsWeb) {
      return downloadImage(image.bytes, fileName);
    }

    /// Show native save file dialog on desktop.
    final String? path = await FilePicker.platform.saveFile(
      type: FileType.image,
      dialogTitle: 'Save Image',
      fileName: fileName,
    );
    if (path == null) return;

    downloadImage(image.bytes, path);
  }

  Future<void> onOpenImage() async {
    if (!_mode.isImage) return;
    final Background? image = _imageIndex == 0 ? _image1 : _image2;
    if (image == null) {
      // ignore: avoid_print
      print('No image url found');
      return;
    }

    Uri uri = Uri.parse(image.url);
    final updatedUri = uri;
    // TODO: enable this for high quality images.
    // final updatedUri = Uri(
    //   scheme: uri.scheme,
    //   host: uri.host,
    //   path: uri.path,
    //   queryParameters: {
    //     // 'ixid': uri.queryParameters['ixid'],
    //     ...uri.queryParameters,
    //     'q': '100',
    //   },
    // );

    await launchUrl(updatedUri);
  }

  Future<String> _getImageUrlFromSource() async {
    switch (_imageSource) {
      case ImageSource.unsplash:
        final String randomImageUrl = _buildUnsplashImageURL(_unsplashSource);
        log('randomImageUrl: $randomImageUrl');
        final redirectionUrl = await _getUrlLocation(randomImageUrl);
        if (redirectionUrl != null) {
          return redirectionUrl;
        } else {
          return randomImageUrl;
        }
      case ImageSource.userLikes:
        assert(_likedBackgrounds.isNotEmpty, 'No liked backgrounds found');
        final LikedBackground background = _likedBackgrounds.values
            .elementAt(Random().nextInt(_likedBackgrounds.length));
        log('liked background url: ${background.url}');
        return background.url;
      case ImageSource.local:
        // TODO: Handle this case.
        throw UnsupportedError('Unsupported background source');
    }
  }

  @action
  Future<void> onToggleLike(bool liked) async {
    final likedBackground = currentImage!.toLikedBackground();
    final String storageKey = StorageKeys.likedBackground(likedBackground.id);
    if (liked) {
      _likedBackgrounds[storageKey] = likedBackground;
    } else {
      _likedBackgrounds.remove(storageKey);
    }
    _likedBackgrounds = _likedBackgrounds;
    if (_imageSource == ImageSource.userLikes && !liked) {
      await storage.clearKey(storageKey);
      await changeBackground();
    } else {
      _debouncer.run(() async {
        log('Saving liked background $liked');
        if (liked) {
          // save
          await storage.setJson(storageKey, likedBackground.toJson());
        } else {
          // remove
          await storage.clearKey(storageKey);
        }
      });
    }
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  @action
  Future<void> reset() async {
    _likedBackgrounds.clear();
    _image1 = null;
    _image2 = null;
    _initialized = false;
    initializationFuture = init();
    await initializationFuture;
  }

  @action
  Future<void> removeLikedPhoto(String key) async {
    _likedBackgrounds.remove(key);
    _likedBackgrounds = _likedBackgrounds;
    await storage.clearKey(key);
  }
}
