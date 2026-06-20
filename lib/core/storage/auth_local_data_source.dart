import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<bool> hasToken();
  Future<void> saveUserData(Map<String, dynamic> userData);
  Future<Map<String, dynamic>?> getUserData();
  Future<void> deleteUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const String _tokenKey = 'cached_auth_token';
  static const String _userDataKey = 'cached_user_data';

  const AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await secureStorage.write(key: _userDataKey, value: json.encode(userData));
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    final rawJson = await secureStorage.read(key: _userDataKey);
    if (rawJson == null) return null;
    try {
      return json.decode(rawJson) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteUserData() async {
    await secureStorage.delete(key: _userDataKey);
  }
}
