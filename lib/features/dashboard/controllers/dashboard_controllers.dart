// lib/features/dashboard/controllers/dashboard_controllers.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/dashboard_models.dart';
import '../../../services/api_service.dart';
import '../../../services/printer_service.dart';

class DashboardController extends GetxController {
  // Instance untuk layanan
  final ApiService _apiService = ApiService();
  final PrinterService _printerService = PrinterService();

  // Controller UI
  final MobileScannerController cameraController = MobileScannerController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController manualTicketController = TextEditingController();

  // State UI
  var isTransactionActive = false.obs;
  var vehicleImageUrl = ''.obs;
  var scannedCode = ''.obs;
  var selectedVehicle = ''.obs;
  var total = 0.obs;

  // State Data Transaksi
  var waktuMasuk = "0000-00-00 00:00:00".obs;
  var waktuScan = "0000-00-00 00:00:00".obs;
  var durasi = "-".obs;
  var transactionData = Rxn<TransactionData>();

  // Getter untuk format Rupiah
  String get formattedTotal {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(total.value);
  }

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
    fetchTicketData(code);
  }

  // DIUBAH: Fungsi ini sekarang memproses data setelah scan
  void fetchTicketData(String ticketCode) {
    // --- SIMULASI MENDAPATKAN DATA ---
    // Di aplikasi nyata, Anda akan memanggil API di sini.
    // Untuk sekarang, kita buat data dummy.
    final entryTime = DateTime.now().subtract(const Duration(hours: 2, minutes: 35)); // Anggap masuk 2 jam 35 menit lalu
    final scanTime = DateTime.now();
    const plateNumber = 'DD 1234 AB';
    const vehicleType = 'Mobil';
    // --- AKHIR SIMULASI ---

    // Tampilkan notifikasi
    Get.snackbar(
      'Scan Berhasil',
      'Kode Tiket: $ticketCode',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Hitung durasi
    final difference = scanTime.difference(entryTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);

    // Update state yang akan ditampilkan di UI
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    waktuMasuk.value = dateFormat.format(entryTime);
    waktuScan.value = dateFormat.format(scanTime);
    durasi.value = '${hours}j ${minutes}m ${seconds}d';
    plateNumberController.text = plateNumber;
    selectVehicle(vehicleType); // Otomatis pilih jenis kendaraan

    // Simpan data transaksi
    transactionData.value = TransactionData(
      plateNumber: plateNumber,
      vehicleType: vehicleType,
      entryTime: entryTime,
      scanTime: scanTime,
      totalCost: 0, // Akan dihitung selanjutnya
    );

    calculateTotal(); // Hitung total biaya
    isTransactionActive.value = true;
  }

  void selectVehicle(String vehicleType) {
    selectedVehicle.value = vehicleType;
  }

  // DIUBAH: Kalkulasi berdasarkan durasi
  void calculateTotal() {
    if (transactionData.value == null) {
      total.value = 0;
      return;
    }

    // Ambil durasi dalam jam, bulatkan ke atas
    int hours = transactionData.value!.scanTime.difference(transactionData.value!.entryTime).inHours;
    if (transactionData.value!.scanTime.difference(transactionData.value!.entryTime).inMinutes.remainder(60) > 0) {
      hours++; // Jika ada sisa menit, hitung sebagai 1 jam
    }
    if (hours == 0) hours = 1; // Parkir minimal 1 jam

    int rate = 0;
    if (selectedVehicle.value.contains('Motor')) {
      rate = 2000;
    } else if (selectedVehicle.value.contains('Mobil')) {
      rate = 5000;
    }
    total.value = rate * hours;
  }

  // BARU: Fungsi untuk membersihkan semua data setelah transaksi
  void clearTransaction() {
    scannedCode.value = '';
    plateNumberController.clear();
    manualTicketController.clear();
    selectedVehicle.value = '';
    total.value = 0;
    waktuMasuk.value = "0000-00-00 00:00:00";
    waktuScan.value = "0000-00-00 00:00:00";
    durasi.value = "-";
    transactionData.value = null;
    isTransactionActive.value = false;
    vehicleImageUrl.value = '';
  }

  void prosesTransaksi() {
    if (manualTicketController.text.isEmpty) {
      Get.snackbar('Gagal', 'Silakan scan atau masukkan kode tiket.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    processTicketCode(manualTicketController.text);
  }

  Future<void> _handlePayment() async {
    if (!isTransactionActive.value || transactionData.value == null) {
      Get.snackbar('Gagal', 'Tidak ada transaksi untuk dibayar.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
      // Panggil service printer
      await _printerService.printReceipt(transactionData.value!, total.value, 'kasir_1');

      // Bersihkan transaksi setelah berhasil cetak
      clearTransaction();
      Get.snackbar('Selesai', 'Transaksi berhasil dan struk tercetak.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error Cetak', e.toString(), backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 5));
    }
  }

  void bayarCash() {
    _handlePayment();
  }

  void bayarQris() {
    _handlePayment();
  }

  @override
  void onClose() {
    plateNumberController.dispose();
    manualTicketController.dispose();
    cameraController.dispose();
    super.onClose();
  }
}