import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // <-- 1. IMPORT PACKAGE

class DashboardController extends GetxController {
  // BARU: Controller untuk kamera scanner
  final MobileScannerController cameraController = MobileScannerController();
  
  // BARU: State untuk menampung hasil scan
  var scannedCode = ''.obs;

  var selectedVehicle = 'Motor'.obs;
  final plateNumberController = TextEditingController();
  var total = 0.obs;
  
  var waktuMasuk = "0000-00-00 00:00:00".obs;
  var waktuScan = "0000-00-00 00:00:00".obs;
  var durasi = "-".obs;

  // BARU: Fungsi yang akan dijalankan ketika QR code terdeteksi
  void onQrCodeDetected(BarcodeCapture capture) {
    // Ambil barcode pertama yang terdeteksi
    final String? code = capture.barcodes.first.rawValue;

    if (code != null) {
      scannedCode.value = code;
      // Beri feedback ke user
      Get.snackbar(
        'Scan Berhasil', 
        'Kode Tiket: $code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Anda bisa menambahkan logic lain di sini,
      // misalnya memanggil API untuk mendapatkan detail tiket.
    }
  }

  // ... (fungsi selectVehicle, calculateTotal, dll tetap sama) ...
  void selectVehicle(String vehicleType) {
    selectedVehicle.value = vehicleType;
    calculateTotal();
  }
  
  void calculateTotal() {
    if (selectedVehicle.value.contains('Motor')) {
      total.value = 2000;
    } else if (selectedVehicle.value.contains('Mobil')) {
      total.value = 5000;
    } else {
      total.value = 0;
    }
  }

  void prosesTransaksi() {
    if (scannedCode.value.isEmpty) {
      Get.snackbar('Gagal', 'Silakan scan tiket terlebih dahulu.');
      return;
    }
    Get.snackbar('Info', 'Memproses transaksi untuk tiket: ${scannedCode.value}');
  }

  void bayarCash() { Get.snackbar('Info', 'Tombol Bayar Cash Ditekan'); }
  void bayarQris() { Get.snackbar('Info', 'Tombol Bayar QRIS Ditekan'); }

  @override
  void onClose() {
    plateNumberController.dispose();
    // PENTING: dispose camera controller untuk membebaskan resource
    cameraController.dispose();
    super.onClose();
  }
}