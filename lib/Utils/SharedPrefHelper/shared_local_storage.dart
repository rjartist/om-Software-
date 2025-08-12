import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;
  static const _coinPopupShownKey = " ";
  static const _userIdKey = "user_id";
   static const _phoneNumberKey = "phone_number";
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

  static Future<void> markCoinPopupShown() async {
    await _prefs?.setBool(_coinPopupShownKey, true);
  }

  static bool hasShownCoinPopup() {
    return _prefs?.getBool(_coinPopupShownKey) ?? false;
  }

  static Future<void> clearAppDataExceptCoinPopup() async {
    final keysToPreserve = {_coinPopupShownKey};

    final allKeys = _prefs?.getKeys() ?? {};
    for (var key in allKeys) {
      if (!keysToPreserve.contains(key)) {
        await _prefs?.remove(key);
      }
    }
  }

  static Future<void> setUserId(int id) async {
    await _prefs?.setInt(_userIdKey, id);
  }

  static int? getUserId() {
    return _prefs?.getInt(_userIdKey);
  }
   static Future<void> setPhoneNumber(String phone) async {
    await _prefs?.setString(_phoneNumberKey, phone);
  }

  static String? getPhoneNumber() {
    return _prefs?.getString(_phoneNumberKey);
  }
}
