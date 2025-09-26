// lib/features/dashboard/views/widgets/header_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/dashboard_controllers.dart';

class HeaderSection extends GetView<DashboardController> {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFF5A623);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // --- PERUBAHAN DI SINI: Menambahkan Row untuk Logo dan Teks ---
          Row(
            children: [
              // 1. Menambahkan logo
              Image.asset(
                'assets/icons/logo-parkways.png',
                height: 40, // Atur tinggi logo sesuai kebutuhan
              ),
              const SizedBox(width: 5), // 2. Memberi jarak antara logo dan teks
              // 3. Teks judul (tidak lagi di dalam Expanded)
              const Text(
                'Parkways Express Payment - BSS Office',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Spacer akan mendorong semua item setelahnya ke kanan
          const Spacer(),
          // --- AKHIR PERUBAHAN ---

          // Bagian kanan header (tombol dan info kasir)
          Row(
            children: [
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
              Obx(() => Text(
                  'Selamat Bekerja\n${controller.username.value}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white70)
              )),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.settings, color: highlightColor, size: 28),
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