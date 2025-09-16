import 'package:flutter/material.dart';
import '../models/tiket_hilang_models.dart';

class LostTicketController {
  var ticket = LostTicketModel();

  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final idNumberController = TextEditingController();
  final postalCodeController = TextEditingController();
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

  void saveTicket() {
    ticket.customerName = customerNameController.text;
    ticket.phoneNumber = phoneController.text;
    ticket.idNumber = idNumberController.text;
    ticket.postalCode = postalCodeController.text;
    ticket.licensePlate = licensePlateController.text;

    if (ticket.customerName.isEmpty || ticket.licensePlate.isEmpty || ticket.vehicleType == null) {
      print("Error: Data Customer, Plat Nomor, dan Jenis Kendaraan wajib diisi!");
      return;
    }

    print("Data Disimpan! Customer: ${ticket.customerName}, Kendaraan: ${ticket.vehicleType}, Biaya: Rp ${ticket.totalFee}");
  }

  void clearForm() {
    customerNameController.clear();
    phoneController.clear();
    idNumberController.clear();
    postalCodeController.clear();
    licensePlateController.clear();
    // Reset model ke kondisi awal
    ticket = LostTicketModel();
  }

  void dispose() {
    customerNameController.dispose();
    phoneController.dispose();
    idNumberController.dispose();
    postalCodeController.dispose();
    licensePlateController.dispose();
  }
}