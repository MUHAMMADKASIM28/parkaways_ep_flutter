import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: const Text(
                'Parkways Express Payment - BSS Office',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.snackbar('Info', 'Tombol Tiket Hilang Ditekan');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('TIKET HILANG', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 24),
              const Text('Selamat Bekerja\nkasir_1', textAlign: TextAlign.right, style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                onPressed: () {
                  Get.snackbar('Info', 'Tombol Pengaturan Ditekan');
                },
                tooltip: 'Pengaturan',
              ),
            ],
          ),
        ],
      ),
    );
  }
}