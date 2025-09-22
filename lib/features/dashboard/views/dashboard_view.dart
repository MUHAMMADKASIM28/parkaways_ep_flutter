// lib/features/dashboard/views/dashboard_view.dart

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
    // Inisialisasi controller saat view ini dibuat
    Get.put(DashboardController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1E1E3F),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderSection(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                    child: ScanSection(),
                  ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(left: 16, bottom: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2F48),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const DurasiSection(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2F48),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const FormKendaraan(),
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