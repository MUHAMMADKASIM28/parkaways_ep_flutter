// lib/features/dashboard/controllers/dashboard_controllers.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/transaction_model.dart';
import '../../../services/api_service.dart';
import '../../../services/printer_service.dart';
import '../../../services/secure_storage_service.dart'; // Impor secure storage
import '../models/dashboard_models.dart';

class DashboardController extends GetxController {
  // --- Inisialisasi Service ---
  final SecureStorageService _storageService = SecureStorageService();
  final PrinterService _printerService = PrinterService();
  late ApiService _apiService;

  // --- Controller UI ---
  final MobileScannerController cameraController = MobileScannerController();
  final TextEditingController platePrefixController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController manualTicketController = TextEditingController();

  // --- State UI & Data ---
  var isTransactionActive = false.obs;
  var vehicleImageUrl = ''.obs;
  var scannedCode = ''.obs;
  var selectedVehicleId = 0.obs;
  var total = 0.obs;
  var waktuMasuk = "0000-00-00 00:00:00".obs;
  var waktuScan = "0000-00-00 00:00:00".obs;
  var durasi = "-".obs;
  var currentTransaction = Rxn<TransactionModel>();

  // Variabel untuk menyimpan data sesi
  String _username = 'kasir_1';
  int _shift = 1;
  int _adminId = 0;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    final ipServer = await _storageService.read('ipServer');
    _apiService = ApiService(ipServer: ipServer ?? '192.168.18.151');

    _username = await _storageService.read('username') ?? 'kasir_1';
    final shiftStr = await _storageService.read('shift');
    if (shiftStr != null) {
      // Ekstrak angka dari string shift (misal: "shift1" -> 1)
      _shift = int.tryParse(shiftStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    }
    final adminIdStr = await _storageService.read('userId');
    _adminId = int.tryParse(adminIdStr ?? '0') ?? 0;

    // Set kode plat default dari storage
    platePrefixController.text = await _storageService.read('locationCode') ?? 'DD';
    _isInitialized = true;
    update(); // Memaksa update UI jika diperlukan
  }

  String get formattedTotal {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(total.value);
  }

  String getFullImageUrl() {
    if (!_isInitialized) return '';
    final String baseUrl = _apiService.baseUrl.replaceAll('/api', '');
    final String imagePath = vehicleImageUrl.value;
    return '$baseUrl/$imagePath';
  }

  void onQrCodeDetected(BarcodeCapture capture) {
    if (!_isInitialized) return;
    final String? code = capture.barcodes.first.rawValue;
    if (code != null && code.isNotEmpty) {
      manualTicketController.text = code;
      prosesTransaksi();
    }
  }

  void prosesTransaksi() {
    if (!_isInitialized) return;
    final String ticketCode = manualTicketController.text;
    if (ticketCode.isEmpty) {
      Get.snackbar('Gagal', 'Silakan scan atau masukkan kode tiket.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    scannedCode.value = ticketCode;
    fetchTicketData(ticketCode);
  }

  Future<void> fetchTicketData(String ticketCode) async {
    if (!_isInitialized) return;
    try {
      final transactionResult = await _apiService.checkTransaction(transactionCode: ticketCode);
      if (transactionResult.status == "success" || transactionResult.status == "sudah") {
        currentTransaction.value = transactionResult;
        waktuMasuk.value = transactionResult.waktuMasuk;
        waktuScan.value = transactionResult.waktuScan;
        durasi.value = transactionResult.durasi;
        vehicleImageUrl.value = transactionResult.camIn;

        final String policeNumberFromApi = transactionResult.policeNumber;
        if (policeNumberFromApi.contains(" ")) {
          final parts = policeNumberFromApi.split(" ");
          platePrefixController.text = parts.first;
          plateNumberController.text = parts.sublist(1).join(" ");
        } else {
          final defaultPrefix = await _storageService.read('locationCode') ?? 'DD';
          platePrefixController.text = defaultPrefix;
          plateNumberController.text = policeNumberFromApi == "-" ? "" : policeNumberFromApi;
        }

        final int vehicleIdFromApi = int.tryParse(transactionResult.vehicleId) ?? 0;
        selectedVehicleId.value = vehicleIdFromApi;
        isTransactionActive.value = transactionResult.status == "success";

        if (transactionResult.status == "sudah") {
          total.value = int.tryParse(transactionResult.total) ?? 0;
          Get.snackbar('Informasi', 'Tiket ini sudah dibayar.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
        } else {
          if (vehicleIdFromApi > 0) {
            await calculateTotal();
          } else {
            total.value = 0;
          }
          Get.snackbar('Berhasil', 'Data tiket ditemukan.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        }
      } else {
        clearTransaction();
        Get.snackbar('Informasi', transactionResult.statusTiket, backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } on ApiException catch (e) {
      clearTransaction();
      Get.snackbar('Error API', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> calculateTotal() async {
    if (!_isInitialized || currentTransaction.value == null || selectedVehicleId.value == 0) {
      total.value = 0;
      return;
    }
    try {
      final String fullPoliceNumber = '${platePrefixController.text} ${plateNumberController.text}';
      final priceResult = await _apiService.checkPrice(
        transactionCode: currentTransaction.value!.transactionCode,
        vehicleId: selectedVehicleId.value,
        policeNumber: fullPoliceNumber.trim().isEmpty ? "-" : fullPoliceNumber.trim(),
      );
      total.value = priceResult['total'] ?? 0;
    } on ApiException catch (e) {
      Get.snackbar('Error Hitung Harga', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void changeVehicle(int newVehicleId) {
    if (!isTransactionActive.value) return;
    selectedVehicleId.value = newVehicleId;
    calculateTotal();
  }

  void clearTransaction() async {
    scannedCode.value = '';
    platePrefixController.text = await _storageService.read('locationCode') ?? 'DD';
    plateNumberController.clear();
    manualTicketController.clear();
    selectedVehicleId.value = 0;
    total.value = 0;
    waktuMasuk.value = "0000-00-00 00:00:00";
    waktuScan.value = "0000-00-00 00:00:00";
    durasi.value = "-";
    currentTransaction.value = null;
    isTransactionActive.value = false;
    vehicleImageUrl.value = '';
  }

  Future<void> _handlePayment(String paymentType) async {
    if (!_isInitialized || !isTransactionActive.value || currentTransaction.value == null) {
      Get.snackbar('Gagal', 'Tidak ada transaksi untuk dibayar.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final String platePrefix = platePrefixController.text;
    final String plateNumber = plateNumberController.text;

    if (platePrefix.isEmpty || plateNumber.isEmpty) {
      Get.snackbar('Validasi Gagal', 'Mohon isi Kode Plat dan Nomor Plat.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedVehicleId.value == 0) {
      Get.snackbar('Validasi Gagal', 'Mohon pilih Jenis Kendaraan.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final String fullPoliceNumber = '$platePrefix $plateNumber';

      await _apiService.updatePayment(
        transactionCode: currentTransaction.value!.transactionCode,
        policeNumber: fullPoliceNumber.trim(),
        shift: _shift,
        total: total.value,
        adminId: _adminId,
        paymentType: paymentType,
        vehicleId: selectedVehicleId.value,
      );

      final printData = TransactionData(
          plateNumber: fullPoliceNumber.trim(),
          vehicleType: selectedVehicleId.value == 1 ? "Motor" : "Mobil",
          entryTime: DateFormat('yyyy-MM-dd HH:mm:ss').parse(waktuMasuk.value),
          scanTime: DateFormat('yyyy-MM-dd HH:mm:ss').parse(waktuScan.value),
          totalCost: total.value
      );

      // Gunakan username yang sudah login untuk nama kasir
      await _printerService.printReceipt(printData, total.value, _username);
      clearTransaction();
      Get.snackbar('Selesai', 'Transaksi berhasil dan struk tercetak.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);

    } on ApiException catch (e) {
      Get.snackbar('Error Pembayaran', e.toString(), backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 5));
    } catch (e) {
      Get.snackbar('Error Cetak', e.toString(), backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 5));
    }
  }

  void bayarCash() => _handlePayment('cash');
  void bayarQris() => _handlePayment('cash');

  @override
  void onClose() {
    platePrefixController.dispose();
    plateNumberController.dispose();
    manualTicketController.dispose();
    cameraController.dispose();
    super.onClose();
  }
}