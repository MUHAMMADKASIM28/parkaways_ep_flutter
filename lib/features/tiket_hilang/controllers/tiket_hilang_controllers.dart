import 'package:flutter/material.dart';
import '../models/tiket_hilang_models.dart';

class LostTicketController {
  var ticket = LostTicketModel();

  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final idNumberController = TextEditingController();
  final platCodeController = TextEditingController();
  final licensePlateController = TextEditingController();

  void selectVehicle(String vehicleName) {
    ticket.vehicleType = vehicleName;

    if (vehicleName == 'Motor') {
      ticket.totalFee = 20000;
    } else if (vehicleName == 'Mobil') {
      ticket.totalFee = 24000;
    } else {
      ticket.totalFee = 0;
    }
  }

  String? saveTicket() {
    ticket.customerName = customerNameController.text;
    ticket.phoneNumber = phoneController.text;
    ticket.idNumber = idNumberController.text;
    ticket.platCode = platCodeController.text;
    ticket.licensePlate = licensePlateController.text; // Pastikan vehicleType sudah di-set

    // Logika Validasi
    if (ticket.customerName.isEmpty || ticket.licensePlate.isEmpty || ticket.vehicleType == null) {
      // Kembalikan pesan error spesifik
      return 'Data tidak lengkap! Mohon isi semua field yang wajib.';
    }

    print("VALIDASI BERHASIL: Data Disimpan!");
    // Kembalikan null jika berhasil
    return null;
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