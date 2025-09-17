// lib/features/settings/controllers/settings_controller.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/settings_models.dart';

class SettingsController {
  var settings = SettingsModel();

  late TextEditingController locationCodeController;
  late TextEditingController ipServerController; // <-- Dikembalikan

  SettingsController() {
    // Inisialisasi data awal (bisa dari login atau penyimpanan lokal)
    settings.ipServer = '';
    settings.username = 'kasir_utama';
    
    // Hubungkan controller ke data awal
    locationCodeController = TextEditingController(text: settings.locationCode);
    ipServerController = TextEditingController(text: settings.ipServer); // <-- Dikembalikan
  }

  void saveLocationCode() {
    settings.locationCode = locationCodeController.text;
    Fluttertoast.showToast(msg: 'Kode Plat berhasil disimpan!');
  }
  
  // Fungsi untuk menyimpan IP Server dikembalikan
  void saveIpServer() {
    settings.ipServer = ipServerController.text;
    print('LOGIC: IP Server disimpan: ${settings.ipServer}');
    Fluttertoast.showToast(msg: 'IP Server berhasil disimpan!');
  }

  void selectPrinter(String newPrinter) {
    settings.selectedPrinter = newPrinter;
    Fluttertoast.showToast(msg: 'Printer diatur ke: $newPrinter');
  }

  void endSession() {
    Fluttertoast.showToast(msg: 'Anda telah keluar.');
  }

  void dispose() {
    locationCodeController.dispose();
    ipServerController.dispose(); // <-- Dikembalikan
  }
}