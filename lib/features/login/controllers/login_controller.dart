// features/login/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart'; // BARU: Impor ApiService

class LoginController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ipServerController = TextEditingController();

  // DIUBAH: Fungsi login sekarang menjadi async untuk menunggu respons API
  Future<void> login({required BuildContext context, required String? shift}) async {
    final String username = usernameController.text;
    final String password = passwordController.text;
    final String ipServer = ipServerController.text;

    // Logika validasi tetap sama
    if (username.isEmpty || password.isEmpty || ipServer.isEmpty || shift == null) {
      _showErrorFlushbar(context, "Mohon lengkapi semua kolom.");
      return; // Hentikan fungsi jika ada field yang kosong
    }

    // --- BARU: Logika untuk memanggil API ---
    try {
      // 1. Buat instance ApiService dengan IP yang diinput dari form
      final apiService = ApiService(ipServer: ipServer);

      // 2. Panggil fungsi loginCashier dan tunggu hasilnya
      final response = await apiService.loginCashier(
        username: username,
        password: password,
      );

      // 3. Cek apakah respons dari API sukses
      if (response.status == "Sukses Login" && response.userId > 0) {
        // Jika berhasil:
        // TODO: Simpan data penting (ipServer, response.userId, shift)
        // ke local storage agar bisa diakses di halaman lain.

        // Pindah ke halaman dashboard
        context.go('/dashboard');
      } else {
        // Jika API mengembalikan status gagal
        _showErrorFlushbar(context, response.status);
      }
    } on ApiException catch (e) {
      // 4. Tangani error spesifik dari ApiService (koneksi, timeout, dll)
      _showErrorFlushbar(context, e.toString());
    } catch (e) {
      // Tangani error tak terduga lainnya
      _showErrorFlushbar(context, "Terjadi kesalahan tidak dikenal: ${e.toString()}");
    }
    // --- AKHIR DARI LOGIKA API ---
  }

  // Helper widget untuk menampilkan notifikasi error secara konsisten
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
      duration: const Duration(seconds: 4), // Perpanjang durasi agar mudah dibaca
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(8),
    ).show(context);
  }
}