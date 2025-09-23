// lib/features/login/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../services/secure_storage_service.dart'; // Impor secure storage service

class LoginController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ipServerController = TextEditingController();
  final SecureStorageService _storageService = SecureStorageService(); // Buat instance service

  LoginController() {
    _loadInitialData();
  }

  // Fungsi untuk memuat data awal
  void _loadInitialData() async {
    ipServerController.text = await _storageService.read('ipServer') ?? '';
  }

  Future<void> login({required BuildContext context, required String? shift}) async {
    final String username = usernameController.text;
    final String password = passwordController.text;
    final String ipServer = ipServerController.text;

    if (username.isEmpty || password.isEmpty || ipServer.isEmpty || shift == null) {
      _showErrorFlushbar(context, "Mohon lengkapi semua kolom.");
      return;
    }

    try {
      final apiService = ApiService(ipServer: ipServer);
      final response = await apiService.loginCashier(
        username: username,
        password: password,
      );

      if (response.status == "Sukses Login" && response.userId > 0) {
        // Simpan data ke secure storage
        await _storageService.write('ipServer', ipServer);
        await _storageService.write('userId', response.userId.toString());
        await _storageService.write('shift', shift);
        await _storageService.write('username', username);

        context.go('/dashboard');
      } else {
        _showErrorFlushbar(context, response.status);
      }
    } on ApiException catch (e) {
      _showErrorFlushbar(context, e.toString());
    } catch (e) {
      _showErrorFlushbar(context, "Terjadi kesalahan tidak dikenal: ${e.toString()}");
    }
  }

  void _showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      maxWidth: 350,
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      backgroundColor: Colors.red.shade700,
      icon: const Icon(Icons.warning, size: 28.0, color: Colors.white),
      titleText: const Text(
        "Login Gagal",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
      duration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(8),
    ).show(context);
  }
}