// lib/features/tiket_hilang/controllers/tiket_hilang_controllers.dart

import 'package:flutter/material.dart';
import '../models/tiket_hilang_models.dart';
import '../../../services/api_service.dart'; // BARU: Impor ApiService

class LostTicketController {
  // --- DIUBAH: Inisialisasi Service ---
  // TODO: Ganti IP hardcoded ini dengan IP yang disimpan dari halaman login
  final ApiService _apiService = ApiService(ipServer: '192.1.18.151');
  var ticket = LostTicketModel();

  // Controller UI (Tetap Sama)
  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final idNumberController = TextEditingController();
  final platCodeController = TextEditingController();
  final licensePlateController = TextEditingController();

  void selectVehicle(String vehicleName) {
    ticket.vehicleType = vehicleName;

    // Logika biaya denda tetap di sisi klien untuk ditampilkan di UI
    // Nilai ini tidak dikirim ke server, server akan menghitungnya sendiri
    if (vehicleName == 'Motor') {
      ticket.totalFee = 20000;
    } else if (vehicleName.contains('Mobil')) { // Dibuat lebih fleksibel
      ticket.totalFee = 24000;
    } else {
      ticket.totalFee = 0;
    }
  }

  // --- DIUBAH: Fungsi saveTicket sekarang async dan memanggil API ---
  Future<String?> saveTicket() async {
    // Mengambil data dari form (Tetap Sama)
    ticket.customerName = customerNameController.text;
    ticket.phoneNumber = phoneController.text;
    ticket.idNumber = idNumberController.text;
    ticket.platCode = platCodeController.text;
    ticket.licensePlate = licensePlateController.text;

    // Logika Validasi (Tetap Sama)
    if (ticket.customerName.isEmpty || ticket.licensePlate.isEmpty || ticket.vehicleType == null) {
      return 'Data tidak lengkap! Mohon isi Nama, No. Plat, dan Jenis Kendaraan.';
    }

    // --- BARU: Logika untuk memanggil API /peplost ---
    try {
      // TODO: Ganti shift dan userId dengan data yang disimpan saat login
      const int currentShift = 1;
      const int userId = 3; // Contoh ID dari API login

      // Mapping nama kendaraan dari UI ke vehicle_id untuk API
      int vehicleId;
      switch (ticket.vehicleType) {
        case 'Motor':
          vehicleId = 1;
          break;
        case 'Mobil':
          vehicleId = 2; // Asumsi 'Mobil' standar adalah ID 2
          break;
        // TODO: Tambahkan case untuk 'Mobil A', 'Mobil B' jika ID-nya berbeda
        default:
          vehicleId = 0; // ID default jika tidak cocok
      }

      // 1. Panggil fungsi processLostTicket dari ApiService
      await _apiService.processLostTicket(
        vehicleId: vehicleId,
        policeNumber: '${ticket.platCode} ${ticket.licensePlate}',
        userId: userId,
        shift: currentShift,
        name: ticket.customerName,
        phone: ticket.phoneNumber.isEmpty ? "-" : ticket.phoneNumber, // Beri nilai default jika kosong
        ktp: ticket.idNumber.isEmpty ? "-" : ticket.idNumber, // Beri nilai default jika kosong
      );

      // 2. Jika panggilan API berhasil tanpa error, kembalikan null
      print("VALIDASI BERHASIL: Data Tiket Hilang Dikirim ke Server!");
      return null;

    } on ApiException catch (e) {
      // 3. Jika ApiService melempar error, kembalikan pesan errornya
      return e.toString();
    } catch (e) {
      // Tangani error tak terduga lainnya
      return "Terjadi kesalahan tidak dikenal: ${e.toString()}";
    }
    // --- AKHIR DARI LOGIKA API ---
  }

  void clearForm() {
    customerNameController.clear();
    phoneController.clear();
    idNumberController.clear();
    platCodeController.clear();
    licensePlateController.clear();
    // Reset model ke kondisi awal
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