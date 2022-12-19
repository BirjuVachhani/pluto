import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:screwdriver/screwdriver.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageManager {
  Future<bool> containsKey(String key);

  Future<Map<String, dynamic>?> getJson(String key);

  Future<bool> setJson(String key, Map<String, dynamic> value);

  Future<bool> clearKey(String key);

  Future<String?> getString(String key);

  Future<bool> setString(String key, String value);

  Future<double?> getDouble(String key);

  Future<bool> setDouble(String key, double value);

  Future<int?> getInt(String key);

  Future<bool> setInt(String key, int value);

  Future<T?> getEnum<T extends Enum>(String key, List<T> values) async {
    return getString(key).then((value) {
      return values.firstWhereOrNull((item) => item.name == value);
    });
  }

  Future<bool> setEnum<T extends Enum>(String key, T value) {
    return setString(key, value.name);
  }

  Future<bool> getBoolean(String key);

  Future<bool> setBoolean(String key, bool value);

  Future<T?> getSerializableObject<T>(
      String key, T Function(Map<String, dynamic> json) fromJson);

  Future<Uint8List?> getBase64(String key);

  Future<bool> setBase64(String key, Uint8List value);

  Future<Set<String>> getKeys();

  Future<void> clear({Iterable<String> except = const []});
}

class SharedPreferencesStorageManager extends LocalStorageManager {
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

  @override
  Future<bool> getBoolean(String key) async => prefs.getBool(key) ?? false;

  @override
  Future<bool> setBoolean(String key, bool value) => prefs.setBool(key, value);

  @override
  Future<T?> getSerializableObject<T>(
      String key, T Function(Map<String, dynamic> json) fromJson) async {
    return getJson(key).then((value) => value != null ? fromJson(value) : null);
  }

  @override
  Future<void> clear({Iterable<String> except = const []}) async {
    final Iterable<String> keys = prefs.getKeys().except(except);
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  @override
  Future<Uint8List?> getBase64(String key) async {
    final data = prefs.getString(key);
    if (data == null) return null;
    return Future.value(base64.decode(data));
  }

  @override
  Future<bool> setBase64(String key, Uint8List value) =>
      prefs.setString(key, base64.encode(value));

  @override
  Future<int?> getInt(String key) async => prefs.getInt(key);

  @override
  Future<bool> setInt(String key, int value) => prefs.setInt(key, value);

  @override
  Future<bool> containsKey(String key) => Future.value(prefs.containsKey(key));

  @override
  Future<Set<String>> getKeys() async => prefs.getKeys();
}
