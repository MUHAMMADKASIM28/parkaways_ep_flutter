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

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Siapkan listener untuk dialog
    _setupDialogListener(context);

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

  // Fungsi untuk "mendengarkan" perubahan pada controller
  void _setupDialogListener(BuildContext context) {
    ever(controller.paidTicketInfo, (Map<String, String>? ticketInfo) {
      if (ticketInfo != null && context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Peringatan'),
              content: Text('Tiket dengan kode transaksi "${ticketInfo['code']}" sudah dibayar.'),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    controller.clearTransaction();
                    // Reset pemicu agar tidak muncul lagi
                    controller.paidTicketInfo.value = null; 
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }
}