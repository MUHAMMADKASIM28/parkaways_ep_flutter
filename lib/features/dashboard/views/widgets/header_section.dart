// lib/features/dashboard/views/widgets/header_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Impor GetX
import 'package:go_router/go_router.dart';
import '../../controllers/dashboard_controllers.dart'; // Impor controller

// --- PERUBAHAN DI SINI ---
class HeaderSection extends GetView<DashboardController> {
// --- AKHIR PERUBAHAN ---
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFF5A623);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
              // --- PERUBAHAN DI SINI ---
              Obx(() => Text(
                  'Selamat Bekerja\n${controller.username.value}', // Ambil username dari controller
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white70)
              )),
              // --- AKHIR PERUBAHAN ---
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