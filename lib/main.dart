import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'home/home.dart';
import 'resources/colors.dart';
import 'utils/storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minima',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(context),
      home: const HomeWrapper(
        key: ValueKey('HomeWrapper'),
      ),
    );
  }
}

Future<void> initialize() async {
  GetIt.instance.registerSingleton<LocalStorageManager>(
      await SharedPreferencesStorageManager.create());
}

ThemeData buildTheme(BuildContext context) {
  return ThemeData(
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      brightness: Brightness.light,
      dividerColor: AppColors.borderColor,
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        verticalOffset: 18,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.black,
        ),
      ),
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          fontWeight: FontWeight.w200,
          color: AppColors.textColor,
        ),
        bodyText2: TextStyle(
          fontWeight: FontWeight.w200,
          color: AppColors.textColor,
        ),
      )
      // fontFamily: FontFamilies.product,
      );
}
