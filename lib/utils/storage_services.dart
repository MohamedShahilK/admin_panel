// ignore_for_file: lines_longer_than_80_chars, avoid_positional_boolean_parameters

import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// GetxService is also used to  serves to control events on each of its pages like GetxController
// But GetxService is not automatically disposed (nor can be removed with Get.delete())

// So it is used for situations like "once started, that """service will remain in memory""", such as Auth control "
// Only way to remove it is Get.reset().

// we can use "to" to access the methods and variables inside of the class
class StorageServices extends GetxService {
  // important
  static StorageServices get to => Get.find();

  late final SharedPreferences _pref;

  Future<StorageServices> init() async {
    _pref = await SharedPreferences.getInstance();
    return this;
  }

  // Removes an entry
  Future<bool> remove(String key) async {
    return _pref.remove(key);
  }

  Future<bool> setString(String key, String value) async {
    return _pref.setString(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    return _pref.setInt(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return _pref.setBool(key, value);
  }

  Future<bool> setList(String key, List<String> value) async {
    return _pref.setStringList(key, value);
  }

  Future<void> saveMapData(String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(data);
    await prefs.setString(key, jsonData);
  }

  String getString(String key) {
    return _pref.getString(key) ?? '';
  }

  int getInt(String key) {
    return _pref.getInt(key) ?? 0;
  }

  bool getBool(String key) {
    return _pref.getBool(key) ?? false;
  }

  List<String> getList(String key) {
    return _pref.getStringList(key) ?? <String>[];
  }

  Future<Map<String, dynamic>> loadMapData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(key);

    if (jsonData != null) {
      return jsonDecode(jsonData) as Map<String, dynamic>;
    } else {
      return {}; // Default empty map if no data is found
    }
  }
}
