import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _accessTokenKey = 'accessToken';
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save tokens
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  // Get access token
  Future<String?> getAccessToken() async => await _storage.read(key: _accessTokenKey);

  // Clear tokens
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
