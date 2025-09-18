import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../controllers/dashboard_controllers.dart';

class ScanSection extends GetView<DashboardController> {
  const ScanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.center, // Opsional: agar konten di tengah vertikal
        children: [
          // DIUBAH: Hapus widget Expanded dari sini
          AspectRatio( // Sekarang AspectRatio menjadi anak langsung dari Column
            aspectRatio: 1, // Ini akan membuat widget menjadi persegi sempurna
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MobileScanner(
                      controller: controller.cameraController,
                      onDetect: controller.onQrCodeDetected,
                    ),
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.yellow,
                    ),
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
                style: TextStyle(
                  color: controller.scannedCode.value.isEmpty ? Colors.white70 : Colors.yellow,
                  fontSize: 16,
                ),
              )),
          const SizedBox(height: 8),
          const Text(
            'Arahkan kamera ke QR Code tiket.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
          const Spacer(), // Spacer tetap di sini untuk mendorong tombol ke bawah
          ElevatedButton(
            onPressed: controller.prosesTransaksi,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5A623),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('PROSES TRANSAKSI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}