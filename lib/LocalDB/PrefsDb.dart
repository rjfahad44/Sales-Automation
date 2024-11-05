

import 'package:shared_preferences/shared_preferences.dart';

class PrefsDb{
  static const USER_DATA = "USER_DATA";
  static const USER_NAME_AND_PASS = "USER_NAME_AND_PASS";
  static const USER_ID = "userID";
  static const USER_PASS = "password";

  Future<void> saveDataToSP(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      print('Unsupported data type for SharedPreferences');
    }
  }

  Future<String> getStringDataSP(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key)??'';
  }

  Future<int> getIntDataSP(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key)??0;
  }

  Future<double> getDoubleDataSP(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key)??0.0;
  }

  Future<bool> getBoolDataSP(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key)??false;
  }

  Future<void> removeDataSP(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

}