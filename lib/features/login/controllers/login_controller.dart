// lib/features/login/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../services/secure_storage_service.dart';
import '../models/location_model.dart';

class LoginController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ipServerController = TextEditingController();
  final SecureStorageService _storageService = SecureStorageService();

  LoginController() {
    _loadInitialData();
  }

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
      final loginResponse = await apiService.loginCashier(
        username: username,
        password: password,
      );

      if (loginResponse.status == "Sukses Login" && loginResponse.userId > 0) {
        // Ambil detail lokasi dari server
        final locationDetails = await apiService.getLocationDetails(1);

        // Simpan semua data sesi dan lokasi
        await _storageService.write('ipServer', ipServer);
        await _storageService.write('userId', loginResponse.userId.toString());
        await _storageService.write('shift', shift);
        await _storageService.write('username', username);
        await _storageService.write('locationName', locationDetails.name);
        await _storageService.write('locationImage', locationDetails.image);
        
        // --- PERUBAHAN DI SINI ---
        // Simpan location_code dari API dengan kunci terpisah
        await _storageService.write('apiLocationCode', locationDetails.locationCode);

        context.go('/dashboard');
      } else {
        _showErrorFlushbar(context, loginResponse.status);
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