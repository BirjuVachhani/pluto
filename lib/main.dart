import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'home/home.dart';
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
      theme: ThemeData(
        brightness: Brightness.light,
        // fontFamily: FontFamilies.product,
      ),
      home: const HomeWrapper(),
    );
  }
}

Future<void> initialize() async {
  GetIt.instance.registerSingleton<StorageManager>(
      await SharedPreferencesStorageManager.create());
}
