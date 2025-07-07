import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;

  // Initialize once at app start
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    if (_prefs == null) return false;
    return await _prefs!.setString(key, value);
  }

  static String? getString(String key) {
    if (_prefs == null) return null;
    return _prefs!.getString(key);
  }

  static Future<bool> remove(String key) async {
    if (_prefs == null) return false;
    return await _prefs!.remove(key);
  }

  static Future<bool> clearAll() async {
    if (_prefs == null) return false;
    return await _prefs!.clear();
  }
}
