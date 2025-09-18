// dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controllers.dart';
import 'widgets/durasi_section.dart';
import 'widgets/form_kendaraan.dart';
import 'widgets/header_section.dart';
import 'widgets/scan_section.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E3F),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderSection(),
            Expanded(
              child: Row(
                children: [
                  // 1. KOLOM KIRI (SCAN) - DIUBAH
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView( // <-- Tambahkan SingleChildScrollView di sini
                      child: ScanSection(),
                    ),
                  ),

                  // 2. KOLOM TENGAH (DURASI) - DIUBAH
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView( // <-- Tambahkan SingleChildScrollView di sini
                      child: Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2F48),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const DurasiSection(),
                      ),
                    ),
                  ),

                  // 3. KOLOM KANAN (FORM KENDARAAN) - DIUBAH
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView( // <-- Tambahkan SingleChildScrollView di sini
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2F48),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const FormKendaraan(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}