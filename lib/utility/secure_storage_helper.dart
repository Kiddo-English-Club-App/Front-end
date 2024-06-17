import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final _storage = FlutterSecureStorage();

  Future<void> storeValue(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print('Error storing value: $e');
    }
  }

  Future<String> getValue(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value ?? '';
    } catch (e) {
      print('Error retrieving value: $e');
      return '';
    }
  }
}