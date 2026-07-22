import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Storage key name (not the API key itself!)
  static const _groqApiKeyName = 'groq_api_key';

  Future<void> saveApiKey(String key) async {
    await _storage.write(
      key: _groqApiKeyName,
      value: key,
    );
  }

  Future<String?> getApiKey() async {
    return await _storage.read(
      key: _groqApiKeyName,
    );
  }

  Future<void> deleteApiKey() async {
    await _storage.delete(
      key: _groqApiKeyName,
    );
  }
}
