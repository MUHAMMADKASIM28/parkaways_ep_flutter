// lib/features/dashboard/controllers/dashboard_controllers.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/transaction_model.dart';
import '../../../services/api_service.dart';
import '../../../services/printer_service.dart';
import '../../../services/secure_storage_service.dart';
import '../models/dashboard_models.dart';
import '../models/vehicle_model.dart';

class DashboardController extends GetxController {
  final SecureStorageService _storageService = SecureStorageService();
  final PrinterService _printerService = PrinterService();
  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;
  late ApiService _apiService;

  final MobileScannerController cameraController = MobileScannerController();
  final TextEditingController platePrefixController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController manualTicketController = TextEditingController();

  var isTransactionActive = false.obs;
  var vehicleImageUrl = ''.obs;
  var scannedCode = ''.obs;
  var selectedVehicleId = 0.obs;
  var total = 0.obs;
  var waktuMasuk = "0000-00-00 00:00:00".obs;
  var waktuScan = "0000-00-00 00:00:00".obs;
  var durasi = "-".obs;
  var currentTransaction = Rxn<TransactionModel>();
  var username = 'kasir_1'.obs;
  var locationName = 'Lokasi Parkir'.obs;
  var locationLogoUrl = ''.obs;
  var vehicles = <Vehicle>[].obs;

  var paidTicketInfo = Rxn<Map<String, String>>();
  var isProcessing = false.obs;

  int _shift = 1;
  int _adminId = 0;
  int _userLocationId = 0;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    final ipServer = await _storageService.read('ipServer');
    _apiService = ApiService(ipServer: ipServer ?? '192.168.1.1');

    username.value = await _storageService.read('username') ?? 'kasir_1';
    locationName.value =
        await _storageService.read('locationName') ?? 'Lokasi Parkir';

    final locationImage = await _storageService.read('locationImage') ?? '';
    if (ipServer != null && locationImage.isNotEmpty) {
      final baseUrl = 'http://$ipServer';
      locationLogoUrl.value = '$baseUrl/$locationImage';
    }

    final shiftStr = await _storageService.read('shift');
    if (shiftStr != null) {
      _shift = int.tryParse(shiftStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    }
    final adminIdStr = await _storageService.read('userId');
    _adminId = int.tryParse(adminIdStr ?? '0') ?? 0;

    final userLocationIdStr = await _storageService.read('userLocationId');
    _userLocationId = int.tryParse(userLocationIdStr ?? '0') ?? 0;
    print('DEBUG: userLocationId yang dimuat untuk QRIS: $_userLocationId');

    await _autoConnectPrinter();
    await _fetchVehicles();

    _isInitialized = true;
    update();
  }

  void bayarQris(BuildContext context) async {
    print('--- DEBUG: Tombol Bayar QRIS diklik ---');

    if (currentTransaction.value == null || total.value <= 0 || !isTransactionActive.value) {
      print('ERROR: Kondisi tidak terpenuhi.');
      Get.snackbar('Gagal', 'Tidak ada transaksi aktif untuk dibayar.', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    
    if (_userLocationId == 0) {
      print('ERROR: userLocationId bernilai 0.');
      Get.snackbar('Error', 'ID Lokasi untuk QRIS tidak ditemukan. Silakan coba login ulang.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isProcessing.value = true;

    try {
      final transaction = currentTransaction.value!;
      print('DEBUG: Memulai generate QR code untuk Transaksi: ${transaction.transactionCode}, Amount: ${total.value}, LocationID: $_userLocationId');
      
      final qrData = await _apiService.generateQrCode(
        transactionCode: transaction.transactionCode,
        amount: total.value,
        locationId: _userLocationId, 
      );

      print('DEBUG: Sukses! Data QR yang disederhanakan diterima dari API: $qrData');

      final vehicle = vehicles.firstWhere((v) => v.vehicleId == selectedVehicleId.value, orElse: () => Vehicle(vehicleId: 0, name: 'Unknown', actived: false, type: ''));

      final args = {
        'transaction': transaction,
        'qrData': qrData, // qrData sekarang sudah dalam format yang benar
        'total': total.value,
        'fullPoliceNumber': '${platePrefixController.text} ${plateNumberController.text}'.trim(),
        'vehicleName': vehicle.name,
      };

      print('DEBUG: Data yang akan dikirim ke halaman QRIS: $args');
      
      if(context.mounted) {
        context.go('/qris-payment', extra: args);
      }

    } on ApiException catch (e) {
      print('ERROR API: Gagal membuat QRIS: $e');
      Get.snackbar('Gagal Membuat QRIS', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      print('ERROR Lainnya: Terjadi kesalahan: $e');
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isProcessing.value = false;
      print('--- DEBUG: Proses Selesai ---');
    }
  }

  // ... (Sisa kode tidak perlu diubah) ...
  
  Future<void> _fetchVehicles() async {
    try {
      final vehicleList = await _apiService.getVehicles();
      vehicles.assignAll(vehicleList
          .where((v) => v.actived && v.type == 'vehicle')
          .toList());
    } on ApiException catch (e) {
      Get.snackbar('Error', 'Gagal memuat jenis kendaraan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _autoConnectPrinter() async {
    try {
      final String? printerAddress =
          await _storageService.read('printerAddress');
      final String? printerName = await _storageService.read('printerName');

      if (printerAddress != null && printerAddress.isNotEmpty) {
        BluetoothDevice device = BluetoothDevice(printerName, printerAddress);
        bool? isConnected = await _printer.isConnected;
        if (isConnected != true) {
          await _printer.connect(device);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Gagal menyambung ulang ke printer.",
        backgroundColor: Colors.orangeAccent,
      );
    }
  }

  String get formattedTotal {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(total.value);
  }

  String getFullImageUrl() {
    if (!_isInitialized) return '';
    final String baseUrl = _apiService.baseUrl.replaceAll('/api', '');
    final String imagePath = vehicleImageUrl.value;
    return '$baseUrl/$imagePath';
  }

  void onQrCodeDetected(BarcodeCapture capture) {
    if (isProcessing.value || !_isInitialized) return;

    final String? code = capture.barcodes.first.rawValue;
    if (code != null && code.isNotEmpty) {
      manualTicketController.text = code;
      prosesTransaksi();
    }
  }

  void prosesTransaksi() {
    if (isProcessing.value) {
      return;
    }

    isProcessing.value = true;

    if (!_isInitialized) {
      isProcessing.value = false;
      return;
    }

    final String ticketCode = manualTicketController.text;
    if (ticketCode.isEmpty) {
      Get.snackbar('Gagal', 'Silakan scan atau masukkan kode tiket.',
          backgroundColor: Colors.red, colorText: Colors.white);
      isProcessing.value = false;
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    scannedCode.value = ticketCode;
    fetchTicketData(ticketCode);
  }

  Future<void> fetchTicketData(String ticketCode) async {
    if (!_isInitialized) {
      isProcessing.value = false;
      return;
    }
    try {
      final transactionResult =
          await _apiService.checkTransaction(transactionCode: ticketCode);

      if (transactionResult.status == "sudah") {
        cameraController.stop();
        currentTransaction.value = transactionResult;
        waktuMasuk.value = transactionResult.waktuMasuk;
        waktuScan.value = transactionResult.waktuScan;
        durasi.value = transactionResult.durasi;
        vehicleImageUrl.value = transactionResult.camIn;
        total.value = int.tryParse(transactionResult.total) ?? 0;
        isTransactionActive.value = false;
        final String policeNumberFromApi = transactionResult.policeNumber;
        final RegExp plateRegex =
            RegExp(r'^([A-Z]{1,2})(\d{1,4})([A-Z]{1,3})$');
        final match = plateRegex.firstMatch(policeNumberFromApi.toUpperCase());
        if (match != null) {
          platePrefixController.text = match.group(1)!;
          plateNumberController.text = '${match.group(2)!} ${match.group(3)!}';
        } else {
          platePrefixController.text = '';
          plateNumberController.text = policeNumberFromApi;
        }
        paidTicketInfo.value = {'code': transactionResult.transactionCode};
      } else if (transactionResult.status == "success") {
        currentTransaction.value = transactionResult;
        waktuMasuk.value = transactionResult.waktuMasuk;
        waktuScan.value = transactionResult.waktuScan;
        durasi.value = transactionResult.durasi;
        vehicleImageUrl.value = transactionResult.camIn;
        isTransactionActive.value = true;
        final String policeNumberFromApi = transactionResult.policeNumber;
        if (policeNumberFromApi.contains(" ")) {
          final parts = policeNumberFromApi.split(" ");
          platePrefixController.text = parts.first;
          plateNumberController.text = parts.sublist(1).join(" ");
        } else {
          platePrefixController.text =
              await _storageService.read('locationCode') ?? '';
          plateNumberController.text =
              policeNumberFromApi == "-" ? "" : policeNumberFromApi;
        }
        final int vehicleIdFromApi =
            int.tryParse(transactionResult.vehicleId) ?? 0;
        selectedVehicleId.value = vehicleIdFromApi;
        if (vehicleIdFromApi > 0) {
          await calculateTotal();
        } else {
          total.value = 0;
        }
        Get.snackbar('Berhasil', 'Data tiket ditemukan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        isProcessing.value = false;
      } else {
        Get.snackbar('Informasi', transactionResult.statusTiket,
            backgroundColor: Colors.orange, colorText: Colors.white);
        clearTransaction();
      }
    } on ApiException catch (e) {
      Get.snackbar('Error API', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      clearTransaction();
    }
  }

  Future<void> calculateTotal() async {
    final transaction = currentTransaction.value;
    if (!_isInitialized || transaction == null || selectedVehicleId.value == 0) {
      total.value = 0;
      return;
    }
    try {
      final String fullPoliceNumber =
          '${platePrefixController.text} ${plateNumberController.text}';
      final priceResult = await _apiService.checkPrice(
        transactionCode: transaction.transactionCode,
        vehicleId: selectedVehicleId.value,
        policeNumber:
            fullPoliceNumber.trim().isEmpty ? "-" : fullPoliceNumber.trim(),
      );
      total.value = priceResult['total'] ?? 0;
    } on ApiException catch (e) {
      Get.snackbar('Error Hitung Harga', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void changeVehicle(int newVehicleId) {
    if (!isTransactionActive.value) return;
    selectedVehicleId.value = newVehicleId;
    calculateTotal();
  }

  void clearTransaction() async {
    scannedCode.value = '';
    platePrefixController.clear();
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
    isProcessing.value = false;
    await Future.delayed(const Duration(milliseconds: 300));
    cameraController.start();
  }

  Future<void> handlePayment(String paymentType, BuildContext context) async {
    if (currentTransaction.value == null || total.value <= 0) {
      Get.snackbar('Gagal', 'Tidak ada transaksi untuk dibayar.',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    final transaction = currentTransaction.value!;
    final fullPoliceNumber =
        '${platePrefixController.text} ${plateNumberController.text}'.trim();

    print("===== DEBUG PEMBAYARAN VIA TERMINAL =====");
    print("Tipe Pembayaran: $paymentType");
    print("Kode Transaksi: ${transaction.transactionCode}");
    print("Nomor Polisi: ${fullPoliceNumber.isEmpty ? "-" : fullPoliceNumber}");
    print("Shift: $_shift");
    print("Total: ${total.value}");
    print("ID Admin: $_adminId");
    print("ID Kendaraan: ${selectedVehicleId.value}");
    print("=========================================");

    try {
      await _apiService.updatePayment(
        transactionCode: transaction.transactionCode,
        policeNumber: fullPoliceNumber.isEmpty ? "-" : fullPoliceNumber,
        shift: _shift,
        total: total.value,
        adminId: _adminId,
        paymentType: paymentType,
        vehicleId: selectedVehicleId.value,
      );
      final vehicle = vehicles.firstWhere(
          (v) => v.vehicleId == selectedVehicleId.value,
          orElse: () =>
              Vehicle(vehicleId: 0, name: 'Unknown', actived: false, type: ''));
      final transactionData = TransactionData(
        transactionCode: transaction.transactionCode,
        plateNumber: fullPoliceNumber,
        vehicleType: vehicle.name,
        entryTime: DateTime.parse(transaction.waktuMasuk),
        scanTime: DateTime.parse(transaction.waktuScan),
        totalCost: total.value,
      );
      await _printerService.printReceipt(
        data: transactionData,
        total: total.value,
        kasir: username.value,
        locationName: locationName.value,
      );
      Get.snackbar('Berhasil', 'Pembayaran berhasil disimpan.',
          backgroundColor: Colors.green, colorText: Colors.white);
      clearTransaction();
      if (context.mounted) {
        context.go('/dashboard');
      }
    } on ApiException catch (e) {
      Get.snackbar('Error Pembayaran', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void bayarCash() => handlePayment('cash', Get.context!);

  @override
  void onClose() {
    platePrefixController.dispose();
    plateNumberController.dispose();
    manualTicketController.dispose();
    cameraController.dispose();
    super.onClose();
  }
}