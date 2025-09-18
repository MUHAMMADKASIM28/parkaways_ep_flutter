// features/login/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:go_router/go_router.dart'; // 1. Impor package go_router

class LoginController {
  // ... (properti controller yang sudah ada)
  final TextEditingController usernameController = TextEditingController(); //
  final TextEditingController passwordController = TextEditingController(); //
  final TextEditingController ipServerController = TextEditingController(); //

  void login({required BuildContext context, required String? shift}) {
    final String username = usernameController.text; //
    final String password = passwordController.text; //
    final String ipServer = ipServerController.text; //

    // Logika validasi
    if (username.isEmpty ||
        password.isEmpty ||
        ipServer.isEmpty ||
        shift == null) { //
      // ... (Kode Flushbar untuk notifikasi error tidak berubah)
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
          "Validasi Gagal",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        messageText: const Text(
          "Mohon lengkapi semua kolom.",
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(8),
        margin: const EdgeInsets.all(8),
      ).show(context); //
    } else {
      // Jika validasi berhasil, pindah ke halaman dashboard
      print("VALIDASI BERHASIL"); //
      print("Username: $username"); //
      print("Password: $password"); //
      print("IP Server: $ipServer"); //
      print("Shift: $shift"); //

      // 2. Gunakan context.go untuk berpindah ke rute dashboard
      context.go('/dashboard');
    }
  }
}