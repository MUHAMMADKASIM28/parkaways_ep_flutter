// lib/services/secure_storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  // Metode umum untuk menyimpan data
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Metode umum untuk membaca data
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Metode umum untuk menghapus data
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}