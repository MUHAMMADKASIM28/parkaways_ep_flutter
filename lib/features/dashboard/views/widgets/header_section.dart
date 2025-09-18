// features/dashboard/views/widgets/header_section.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 1. Pastikan go_router sudah diimpor

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ... (Widget lain tidak berubah)
          const Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'Parkways Express Payment - BSS Office',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              // ... Tombol TIKET HILANG
              ElevatedButton(
                onPressed: () {
                  context.go('/lost-ticket');
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
                // 2. Ubah onPressed untuk navigasi ke halaman pengaturan
                onPressed: () {
                  context.go('/settings');
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