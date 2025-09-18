// header_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX untuk menampilkan notifikasi

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Parkways Express Payment - BSS Office',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Tambahkan logika untuk tiket hilang di sini
                  Get.snackbar('Info', 'Tombol Tiket Hilang Ditekan');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  // DIUBAH: Mengurangi lengkungan sudut agar lebih kotak
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Angka lebih kecil = lebih kotak
                  ),
                ),
                child: const Text(
                  'TIKET HILANG',
                  style: TextStyle(color: Colors.white), // Seperti ini
                ),
              ),
              const SizedBox(width: 24),
              const Text('Selamat Bekerja\nkasir_1', textAlign: TextAlign.right, style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 16),
              // DIUBAH: Bungkus Icon dengan IconButton agar bisa diklik
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                onPressed: () {
                  // Tambahkan logika untuk pengaturan di sini
                  Get.snackbar('Info', 'Tombol Pengaturan Ditekan');
                },
                tooltip: 'Pengaturan', // Teks yang muncul saat mouse hover
              ),
            ],
          ),
        ],
      ),
    );
  }
}