// lib/features/dashboard/views/widgets/scan_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../controllers/dashboard_controllers.dart';

class ScanSection extends GetView<DashboardController> {
  const ScanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.black,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // --- PERUBAHAN DI SINI ---
                            // Bungkus MobileScanner dengan RotatedBox
                            RotatedBox(
                              quarterTurns: -1, // -1 untuk putar 90 derajat ke kiri
                              child: MobileScanner(
                                controller: controller.cameraController,
                                onDetect: controller.onQrCodeDetected,
                              ),
                            ),
                            // --- AKHIR PERUBAHAN ---
                            Container(width: double.infinity, height: 2, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Text(
                    controller.scannedCode.value.isEmpty
                        ? 'Scan tiket di area scanner'
                        : 'Hasil Scan: ${controller.scannedCode.value}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFF5A623), fontSize: 16),
                  )),
                  const SizedBox(height: 24),
                  TextField(
                    controller: controller.manualTicketController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'atau masukkan kode tiket',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF2C2F48),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.yellow),
                      ),
                    ),
                    onSubmitted: (_) => controller.prosesTransaksi(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.prosesTransaksi,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5A623),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('PROSES TRANSAKSI',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }
}