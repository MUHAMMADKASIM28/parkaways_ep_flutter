import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/dashboard_models.dart';

class DashboardController extends GetxController {
  // Controller Kamera & UI
  final MobileScannerController cameraController = MobileScannerController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController manualTicketController = TextEditingController();

  // State untuk mengontrol status form dan UI lainnya
  var isTransactionActive = false.obs;
  var vehicleImageUrl = ''.obs;

  // State Management
  var scannedCode = ''.obs;
  // DIUBAH: Nilai awal dikosongkan agar tidak ada yang terpilih
  var selectedVehicle = ''.obs;
  var total = 0.obs;

  // State untuk detail transaksi
  var waktuMasuk = "0000-00-00 00:00:00".obs;
  var waktuScan = "0000-00-00 00:00:00".obs;
  var durasi = "-".obs;
  var transactionData = Rxn<TransactionData>();

  @override
  void onInit() {
    super.onInit();
    isTransactionActive.value = false;
  }

  void onQrCodeDetected(BarcodeCapture capture) {
    final String? code = capture.barcodes.first.rawValue;
    if (code != null && code.isNotEmpty) {
      manualTicketController.text = code;
      processTicketCode(code);
    }
  }

  void processTicketCode(String code) {
    if (code.isEmpty) return;
    scannedCode.value = code;
    Get.snackbar(
      'Tiket Ditemukan',
      'Kode Tiket: $code',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    fetchTicketData(code);
  }

  void fetchTicketData(String ticketCode) {
    final Map<String, dynamic> fetchedData = {
      'plateNumber': 'DD 1234 XY',
      'vehicleType': 'Mobil',
      'entryTime': DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
    };

    if (fetchedData['vehicleType'] == 'Mobil') {
      vehicleImageUrl.value = 'assets/mobil.png';
    } else if (fetchedData['vehicleType'] == 'Motor') {
      vehicleImageUrl.value = 'assets/motor.png';
    } else {
      vehicleImageUrl.value = '';
    }

    final entryTimeFromQR = fetchedData['entryTime'];
    final scanTime = DateTime.now();
    final difference = scanTime.difference(entryTimeFromQR);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    waktuMasuk.value = dateFormat.format(entryTimeFromQR);
    waktuScan.value = dateFormat.format(scanTime);
    durasi.value = '${hours} Jam ${minutes} Menit ${seconds} Detik';
    plateNumberController.text = fetchedData['plateNumber'];
    selectVehicle(fetchedData['vehicleType']);

    transactionData.value = TransactionData(
      plateNumber: fetchedData['plateNumber'],
      vehicleType: fetchedData['vehicleType'],
      entryTime: entryTimeFromQR,
      scanTime: scanTime,
      totalCost: 0,
    );
    calculateTotal();
    isTransactionActive.value = true;
  }

  void selectVehicle(String vehicleType) {
    selectedVehicle.value = vehicleType;
  }

  void calculateTotal() {
    if (transactionData.value == null) {
      total.value = 0;
      return;
    }
    if (selectedVehicle.value.contains('No Bill')) {
      total.value = 0;
      return;
    }
    int hours = transactionData.value!.scanTime.difference(transactionData.value!.entryTime).inHours;
    if (transactionData.value!.scanTime.difference(transactionData.value!.entryTime).inMinutes.remainder(60) > 5) {
      hours++;
    }
    if (hours == 0) hours = 1;
    int rate = 0;
    if (selectedVehicle.value.contains('Motor')) {
      rate = 2000;
    } else if (selectedVehicle.value.contains('Mobil')) {
      rate = 5000;
    }
    total.value = rate * hours;
  }

  void clearTransaction() {
    scannedCode.value = '';
    plateNumberController.clear();
    manualTicketController.clear();
    // DIUBAH: Reset kembali ke string kosong
    selectedVehicle.value = '';
    total.value = 0;
    waktuMasuk.value = "0000-00-00 00:00:00";
    waktuScan.value = "0000-00-00 00:00:00";
    durasi.value = "-";
    transactionData.value = null;
    isTransactionActive.value = false;
    vehicleImageUrl.value = '';

    Get.snackbar('Selesai', 'Transaksi berhasil, siap untuk berikutnya.',
        snackPosition: SnackPosition.BOTTOM);
  }

  void prosesTransaksi() {
    if (manualTicketController.text.isEmpty) {
      Get.snackbar('Gagal', 'Silakan scan atau masukkan kode tiket.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    processTicketCode(manualTicketController.text);
  }

  void bayarCash() {
    if (!isTransactionActive.value) {
      Get.snackbar('Gagal', 'Tidak ada transaksi untuk dibayar.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    clearTransaction();
  }

  void bayarQris() {
    if (!isTransactionActive.value) {
      Get.snackbar('Gagal', 'Tidak ada transaksi untuk dibayar.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    clearTransaction();
  }

  @override
  void onClose() {
    plateNumberController.dispose();
    manualTicketController.dispose();
    cameraController.dispose();
    super.onClose();
  }
}