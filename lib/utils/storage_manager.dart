import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageManager {
  Future<Map<String, dynamic>?> getJson(String key);

  Future<bool> setJson(String key, Map<String, dynamic> value);

  Future<bool> clearKey(String key);

  Future<String?> getString(String key);

  Future<bool> setString(String key, String value);

  Future<double?> getDouble(String key);

  Future<bool> setDouble(String key, double value);

  Future<T?> getEnum<T extends Enum>(String key, List<T> values) async {
    return getString(key).then((value) {
      return values.firstWhereOrNull((item) => item.name == value);
    });
  }

  Future<bool> setEnum<T extends Enum>(String key, T value) {
    return setString(key, value.name);
  }
}

class SharedPreferencesStorageManager extends StorageManager {
  SharedPreferencesStorageManager._(this.prefs);

  final SharedPreferences prefs;

  static Future<SharedPreferencesStorageManager> create() async {
    return SharedPreferencesStorageManager._(
        await SharedPreferences.getInstance());
  }

  @override
  Future<Map<String, dynamic>?> getJson(String key) async {
    final data = prefs.getString(key);
    if (data == null) return null;
    return json.decode(data);
  }

  @override
  Future<bool> setJson(String key, Map<String, dynamic> value) =>
      prefs.setString(key, json.encode(value));

  @override
  Future<bool> clearKey(String key) => prefs.remove(key);

  @override
  Future<double?> getDouble(String key) async => prefs.getDouble(key);

  @override
  Future<String?> getString(String key) async => prefs.getString(key);

  @override
  Future<bool> setDouble(String key, double value) async =>
      prefs.setDouble(key, value);

  @override
  Future<bool> setString(String key, String value) =>
      prefs.setString(key, value);
}
