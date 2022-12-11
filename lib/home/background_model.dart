import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:screwdriver/screwdriver.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/background_settings.dart';
import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../model/unsplash_collection.dart';
import '../resources/storage_keys.dart';
import '../utils/extensions.dart';
import '../utils/storage_manager.dart';
import '../utils/universal/universal.dart';
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
  Size windowSize = const Size(1920, 1080);

  bool isLoadingImage = false;

  bool showLoadingBackground = false;

  /// In memory copy of the cached images.
  Background? image1;
  Background? image2;
  Map<String, LikedBackground> likedBackgrounds = {};

  /// indicates that a like save operation is in progress
  ValueNotifier<bool> likeSaveNotifier = ValueNotifier(false);

  late Future initializationFuture;

  BackgroundMode get mode => settings.mode;

  FlatColor get color => settings.color;

  ColorGradient get gradient => settings.gradient;

  double get tint => settings.tint;

  bool get texture => settings.texture;

  bool get invert => settings.invert;

  bool get greyScale => settings.greyScale;

  ImageSource get imageSource => settings.source;

  UnsplashSource get unsplashSource => settings.unsplashSource;

  ImageRefreshRate get imageRefreshRate => settings.imageRefreshRate;

  int get imageIndex => settings.imageIndex;

  ImageResolution get imageResolution => settings.imageResolution;

  bool isLiked(String id) =>
      likedBackgrounds.containsKey(StorageKeys.likedBackground(id));

  void setMode(BackgroundMode mode);

  void setColor(FlatColor color);

  void setGradient(ColorGradient gradient);

  void setTint(double tint);

  void setTexture(bool texture);

  void setInvert(bool invert);

  void setImageSource(ImageSource source);

  void setUnsplashSource(UnsplashSource source);

  void setImageRefreshRate(ImageRefreshRate rate);

  void setImageResolution(ImageResolution resolution);

  void setGreyScale(bool greyScale);

  Color getForegroundColor();

  Future<void> changeBackground({bool updateAll = false});

  Future<void> onDownload();

  Future<void> onOpenImage();

  Background? getImage();

  void onTimerCallback();

  Future<void> onToggleLike(bool liked);

  Future<void> reset();
}

class BackgroundModel extends BackgroundModelBase {
  late final LocalStorageManager storage =
      GetIt.instance.get<LocalStorageManager>();

  /// Latest background change time.
  late DateTime backgroundLastUpdated;

  late final DeBouncer _debouncer = DeBouncer(const Duration(seconds: 1));

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
    if (imageSource == ImageSource.unsplash ||
        imageSource == ImageSource.userLikes) {
      if (!await storage.containsKey(StorageKeys.image1)) {
        // If no images are cached, fetch new ones now and cache them.
        _loadImageFromSource().then((result) {
          if (result == null) return;
          image1 = result;
          storage.setJson(StorageKeys.image1, result.toJson());
        });
      } else {
        // If images are cached, load them.
        image1 = await storage.getSerializableObject(
            StorageKeys.image1, Background.fromJson);
      }
      if (!await storage.containsKey(StorageKeys.image2)) {
        // If no images are cached, fetch new ones now and cache them.
        _loadImageFromSource().then((result) {
          if (result == null) return;
          image2 = result;
          storage.setJson(StorageKeys.image2, result.toJson());
        });
      } else {
        // If images are cached, load them.
        image2 = await storage.getSerializableObject(
            StorageKeys.image2, Background.fromJson);
      }
      final future = _loadLikedBackgrounds();
      if (imageSource == ImageSource.userLikes) {
        // If the user likes are the source, we need to wait for the liked
        // backgrounds to load before we can load the image.
        log('Waiting for liked backgrounds to load');
        await future;
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
    this.likedBackgrounds = likedBackgrounds;
  }

  /// Responsible for fetching and caching the image other than the current
  /// image.
  Future<void> _refetchAndCacheOtherImage() async {
    log('refetchAndCacheOtherImage');
    _loadImageFromSource().then((result) {
      if (result == null) return;
      // We only update the image that is not currently being used so it can
      // be used next time when the user opens a new tab.
      if (imageIndex == 0) {
        image2 = result;
        storage.setJson(StorageKeys.image2, result.toJson());
      } else {
        image1 = result;
        storage.setJson(StorageKeys.image1, result.toJson());
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
      if (imageIndex == 0) {
        image1 = result;
        storage.setJson(StorageKeys.image1, result.toJson());
      } else {
        image2 = result;
        storage.setJson(StorageKeys.image2, result.toJson());
      }
    });
    if (updateAll) {
      // Most probably the image source changed, so we need to update the other
      // cached image as well.
      await _loadImageFromSource().then((result) {
        if (result == null) return;
        // Update the other image(not current one) and cache it.
        if (imageIndex == 0) {
          image2 = result;
          storage.setJson(StorageKeys.image2, result.toJson());
        } else {
          image1 = result;
          storage.setJson(StorageKeys.image1, result.toJson());
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
    // Update the current image to the new source.
    changeBackground(updateAll: true);
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

  @override
  void setImageResolution(ImageResolution resolution) {
    settings = settings.copyWith(imageResolution: resolution);
    _save();
    changeBackground(updateAll: true);
    notifyListeners();
  }

  @override
  void setGreyScale(bool greyScale) {
    settings = settings.copyWith(greyScale: greyScale);
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
  Background? getImage() {
    if (!mode.isImage) return null;
    final image = imageIndex == 0 ? image1 : image2;
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
  /// Setting [isLoadingImage] to true will only show a loading indicator in
  /// the bottom of the page.
  ///
  /// Returns a [MapEntry] where key is the original image URL and the value
  /// is the image bytes. The key will be an empty string if the original image
  /// URL could not be retrieved.
  ///
  /// Returns null if the image could not be fetched.
  Future<Background?> _loadImageFromSource({
    bool showLoadingBackground = false,
  }) async {
    log('loadImageFromSource');
    isLoadingImage = true;
    // This means that only show loading image background(grey scale) when
    // explicitly told to.
    this.showLoadingBackground = showLoadingBackground;
    notifyListeners();

    try {
      // Fetch the image from unsplash.
      final String actualImageUrl = await _getImageUrlFromSource();
      log('actualUrl: $actualImageUrl');
      final http.Response response = await http.get(Uri.parse(actualImageUrl));
      isLoadingImage = false;
      this.showLoadingBackground = false;
      notifyListeners();
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
      isLoadingImage = false;
      this.showLoadingBackground = false;
      notifyListeners();
      return null;
    }
  }

  /// Constructs an image URL of Unsplash based on the current settings.
  String _buildUnsplashImageURL(UnsplashSource source) {
    final Size size = imageResolution.toSize() ?? windowSize;
    return 'https://source.unsplash.com${source.getPath()}/${size.width.toInt()}x${size.height.toInt()}';
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

  @override
  Future<void> onDownload() async {
    final Background? image = getImage();
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

  @override
  Future<void> onOpenImage() async {
    if (!mode.isImage) return;
    final Background? image = imageIndex == 0 ? image1 : image2;
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
    switch (imageSource) {
      case ImageSource.unsplash:
        final String randomImageUrl = _buildUnsplashImageURL(unsplashSource);
        log('randomImageUrl: $randomImageUrl');
        final redirectionUrl = await _getUrlLocation(randomImageUrl);
        if (redirectionUrl != null) {
          return redirectionUrl;
        } else {
          return randomImageUrl;
        }
      case ImageSource.userLikes:
        assert(likedBackgrounds.isNotEmpty, 'No liked backgrounds found');
        final LikedBackground background = likedBackgrounds.values
            .elementAt(Random().nextInt(likedBackgrounds.length));
        log('liked background url: ${background.url}');
        return background.url;
      case ImageSource.local:
        // TODO: Handle this case.
        throw UnsupportedError('Unsupported background source');
    }
  }

  @override
  Future<void> onToggleLike(bool liked) async {
    final likedBackground = getImage()!.toLikedBackground();
    final String storageKey = StorageKeys.likedBackground(likedBackground.id);
    if (liked) {
      likedBackgrounds[storageKey] = likedBackground;
    } else {
      likedBackgrounds.remove(storageKey);
    }
    notifyListeners();
    if (imageSource == ImageSource.userLikes && !liked) {
      likeSaveNotifier.value = true;
      await storage.clearKey(storageKey);
      likeSaveNotifier.value = false;
      await changeBackground();
    } else {
      _debouncer.run(() async {
        log('Saving liked background $liked');
        likeSaveNotifier.value = true;
        if (liked) {
          // save
          await storage.setJson(storageKey, likedBackground.toJson());
        } else {
          // remove
          await storage.clearKey(storageKey);
        }
        likeSaveNotifier.value = false;
      });
    }
  }

  @override
  void dispose() {
    _debouncer.cancel();
    likeSaveNotifier.dispose();
    super.dispose();
  }

  @override
  Future<void> reset() async {
    likedBackgrounds.clear();
    image1 = null;
    image2 = null;
    initialized = false;
    initializationFuture = init();
    notifyListeners();
    await initializationFuture;
  }
}
