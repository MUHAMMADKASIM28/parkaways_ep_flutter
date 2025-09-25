// lib/features/tiket_hilang/controllers/tiket_hilang_controllers.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../models/tiket_hilang_models.dart';
import '../../../services/api_service.dart';
import '../../../services/secure_storage_service.dart';
import '../../../services/printer_service.dart';

class LostTicketController {
  final SecureStorageService _storageService = SecureStorageService();
  final PrinterService _printerService = PrinterService();
  late ApiService _apiService;

  var ticket = LostTicketModel();

  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final idNumberController = TextEditingController();
  final platCodeController = TextEditingController();
  final licensePlateController = TextEditingController();

  LostTicketController() {
    _initializeController();
  }

  Future<void> _initializeController() async {
    final ipServer = await _storageService.read('ipServer');
    _apiService = ApiService(ipServer: ipServer ?? '192.168.1.1'); // Fallback IP
  }

  void selectVehicle(String vehicleName) {
    ticket.vehicleType = vehicleName;

    if (vehicleName == 'Motor') {
      ticket.totalFee = 24000;
    } else if (vehicleName == 'Mobil') {
      ticket.totalFee = 20000;
    } else {
      ticket.totalFee = 0;
    }
  }

  Future<String?> saveTicket() async {
    ticket.customerName = customerNameController.text;
    ticket.phoneNumber = phoneController.text;
    ticket.idNumber = idNumberController.text;
    ticket.platCode = platCodeController.text;
    ticket.licensePlate = licensePlateController.text;

    if (ticket.customerName.isEmpty ||
        ticket.licensePlate.isEmpty ||
        ticket.vehicleType == null) {
      return 'Data tidak lengkap! Mohon isi Nama, No. Plat, dan Jenis Kendaraan.';
    }

    try {
      // Ambil shift dan userId dari storage
      final shiftStr = await _storageService.read('shift');
      final userIdStr = await _storageService.read('userId');

      final int currentShift =
          int.tryParse(shiftStr?.replaceAll(RegExp(r'[^0-9]'), '') ?? '1') ?? 1;
      final int userId = int.tryParse(userIdStr ?? '0') ?? 0;

      int vehicleId;
      switch (ticket.vehicleType) {
        case 'Motor':
          vehicleId = 1;
          break;
        case 'Mobil':
          vehicleId = 2;
          break;
        default:
          vehicleId = 0;
      }

      await _apiService.processLostTicket(
        vehicleId: vehicleId,
        policeNumber: '${ticket.platCode} ${ticket.licensePlate}',
        userId: userId,
        shift: currentShift,
        name: ticket.customerName,
        phone: ticket.phoneNumber.isEmpty ? "-" : ticket.phoneNumber,
        ktp: ticket.idNumber.isEmpty ? "-" : ticket.idNumber,
      );

      print("VALIDASI BERHASIL: Data Tiket Hilang Dikirim ke Server!");
      return null;
    } on ApiException catch (e) {
      return e.toString();
    } catch (e) {
      return "Terjadi kesalahan tidak dikenal: ${e.toString()}";
    }
  }

  // --- FUNGSI BARU UNTUK CETAK STRUK ---
  Future<void> printLostTicketReceipt(BuildContext context) async {
    try {
      final username = await _storageService.read('username') ?? 'kasir';
      await _printerService.printLostTicketReceipt(ticket, username);
    } catch (e) {
      // Cek apakah widget masih ada di tree sebelum menampilkan toast
      if (!context.mounted) return;
      Fluttertoast.showToast(
        msg: "Gagal mencetak struk: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }
  // --- AKHIR PERUBAHAN ---

  void clearForm() {
    customerNameController.clear();
    phoneController.clear();
    idNumberController.clear();
    platCodeController.clear();
    licensePlateController.clear();
    ticket = LostTicketModel();
  }

  void dispose() {
    customerNameController.dispose();
    phoneController.dispose();
    idNumberController.dispose();
    platCodeController.dispose();
    licensePlateController.dispose();
  }
}