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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // Widget untuk menampilkan logo dari aset lokal
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Image.asset(
                    'assets/icons/logo-parkways.png', // Ganti dengan path gambar lokal Anda
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                  ),
                ),

                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Obx(() => Text(
                      'Parkways Express Payment - ${controller.locationName.value}',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    )),
                  ),
                ),
              ],
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