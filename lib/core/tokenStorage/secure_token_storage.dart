import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  String? _token;
  static const String _tokenKey = "key_saved_token";
  final _storage = const FlutterSecureStorage();

  SecureTokenStorage._();

  static Future<SecureTokenStorage> init() async {
    final instance = SecureTokenStorage._();
    await instance._loadToken();
    return instance;
  }

  ///
  /// get and read value
  ///

  Future<String?> _getValue({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e, stackTrace) {
      debugPrint("$e\n$stackTrace");
      return null;
    }
  }

  Future<void> _setValue({required String key, required String? value}) async {
    if (value != null) {
      _storage.write(key: key, value: value);
    } else {
      _storage.delete(key: key);
    }
  }

  Future<void> _loadToken() async {
    _token = await _getValue(key: _tokenKey);
  }

  ///
  /// token
  ///

  String? get authToken => _token;

  void setToken(String value) {
    _token = value;
    _setValue(key: _tokenKey, value: value);
  }

  void deleteToken() {
    _token = null;
    _setValue(key: _tokenKey, value: null);
  }
}
