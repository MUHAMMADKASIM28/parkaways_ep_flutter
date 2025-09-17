import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class LoginController {
  // 1. Buat TextEditingController untuk setiap TextField
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ipServerController = TextEditingController();

  // 2. Buat fungsi untuk logika login/validasi
  void login({required BuildContext context, required String? shift}) {
    // Ambil nilai teks dari setiap controller
    final String username = usernameController.text;
    final String password = passwordController.text;
    final String ipServer = ipServerController.text;

    // 3. Logika validasi
    // Pastikan untuk mengimpor 'package:another_flushbar/flushbar.dart';

    if (username.isEmpty ||
        password.isEmpty ||
        ipServer.isEmpty ||
        shift == null) {
      Flushbar(
        // Mengubah posisi ke atas layar
        flushbarPosition: FlushbarPosition.TOP,

        // Membatasi lebar flushbar agar lebih kecil
        maxWidth: 350,

        // Memberi bayangan agar terlihat mengambang
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
      ).show(context);
    } else {
      // Jika semua terisi, lanjutkan proses (untuk saat ini kita print saja)
      print("VALIDASI BERHASIL");
      print("Username: $username");
      print("Password: $password");
      print("IP Server: $ipServer");
      print("Shift: $shift");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login berhasil!"),
          backgroundColor: Colors.green,
        ),
      );
      // Di sini Anda nantinya akan memanggil API, dll.
    }
  }
}
