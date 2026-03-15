import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import 'backend/backend_service.dart';
import 'backend/rest_backend_service.dart';
import 'home/home.dart';
import 'resources/colors.dart';
import 'utils/drop_delegate.dart';
import 'utils/geocoding_service.dart';
import 'utils/storage_manager.dart';
import 'utils/weather_service.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  for (var view in binding.renderViews) {
    view.automaticSystemUiAdjustment = false;
  }
  await initialize();
  runApp(const MyApp());
}

late PackageInfo packageInfo;

Future<void> loadPackageInfo() async => packageInfo = await PackageInfo.fromPlatform();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<bool> _windowDragNotifier = ValueNotifier(false);
  late final DragAndDropDelegate _dropDelegate = DragAndDropDelegate(
    dragNotifier: _windowDragNotifier,
  );

  @override
  Widget build(BuildContext context) {
    return DebugRender(
      debugHighlightObserverRebuild: false,
      child: MaterialApp(
        title: 'Pluto',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(context),
        builder: (context, child) => DropRegion(
          formats: Formats.standardFormats,
          onDropEnter: (_) => _windowDragNotifier.value = true,
          onDropLeave: (_) => _windowDragNotifier.value = false,
          onDropOver: (_) => DropOperation.copy,
          onPerformDrop: (_) async => _windowDragNotifier.value = false,
          child: DragAndDropScope(
            delegate: _dropDelegate,
            child: child!,
          ),
        ),
        home: const HomeWrapper(
          key: ValueKey('HomeWrapper'),
        ),
      ),
    );
  }
}

Future<void> initialize() async {
  await initializeBackend();

  final storage = await SharedPreferencesStorageManager.create();
  GetIt.instance.registerSingleton<LocalStorageManager>(storage);
  GetIt.instance.registerSingleton<WeatherService>(OpenMeteoWeatherService());
  GetIt.instance.registerSingleton<GeocodingService>(OpenMeteoGeocodingService());

  await GetIt.instance.allReady();
  await loadPackageInfo();
}

Future<void> initializeBackend() async {
  // Initialize Celest
  final BackendService service = await getBackend();

  await service.init(local: useLocalServer);

  GetIt.instance.registerSingleton<BackendService>(service);
}

Future<BackendService> getBackend() async => RestBackendService();

ThemeData buildTheme(BuildContext context) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: CupertinoColors.systemBlue,
      brightness: Brightness.dark,
      primary: CupertinoColors.systemBlue,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    // canvasColor: Colors.black,
    // cardColor: Colors.black,
    brightness: Brightness.dark,
    dividerColor: AppColors.borderColor,
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStateProperty.all(4),
      thumbVisibility: WidgetStateProperty.all(true),
    ),
    // fontFamily: FontFamilies.product,
    tooltipTheme: TooltipThemeData(
      waitDuration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      verticalOffset: 18,
      textStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white60,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        color: Colors.grey.shade900,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.textColor,
      ),
      displayMedium: TextStyle(
        color: AppColors.textColor,
      ),
      displaySmall: TextStyle(
        color: AppColors.textColor,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textColor,
      ),
      headlineSmall: TextStyle(
        color: AppColors.textColor,
      ),
      titleLarge: TextStyle(
        color: AppColors.textColor,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textColor,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textColor,
      ),
    ),
  );
}

class DebugRender extends InheritedWidget {
  final bool debugHighlightObserverRebuild;

  const DebugRender({
    super.key,
    this.debugHighlightObserverRebuild = false,
    required super.child,
  });

  static DebugRender? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DebugRender>();
  }

  @override
  bool updateShouldNotify(covariant DebugRender oldWidget) {
    return debugHighlightObserverRebuild != oldWidget.debugHighlightObserverRebuild;
  }
}
