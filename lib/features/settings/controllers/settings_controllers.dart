// lib/features/settings/controllers/settings_controller.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart'; // 1. Impor go_router
import '../models/settings_models.dart';

class SettingsController {
  var settings = SettingsModel();
  late TextEditingController locationCodeController;
  late TextEditingController ipServerController;

  SettingsController() {
    settings.ipServer = '192.168.100.5';
    settings.username = 'kasir_utama';
    locationCodeController = TextEditingController(text: settings.locationCode);
    ipServerController = TextEditingController(text: settings.ipServer);
  }

  // ... (fungsi lain tidak berubah)
  void saveLocationCode() {
    settings.locationCode = locationCodeController.text;
    Fluttertoast.showToast(msg: 'Kode Plat berhasil disimpan!');
  }
  
  void saveIpServer() {
    settings.ipServer = ipServerController.text;
    print('LOGIC: IP Server disimpan: ${settings.ipServer}');
    Fluttertoast.showToast(msg: 'IP Server berhasil disimpan!');
  }

  void selectPrinter(String newPrinter) {
    settings.selectedPrinter = newPrinter;
    Fluttertoast.showToast(msg: 'Printer diatur ke: $newPrinter');
  }

  // 2. Tambahkan BuildContext dan panggil navigasi di sini
  void endSession(BuildContext context) {
    // Navigasi kembali ke halaman login dan hapus semua halaman sebelumnya
    context.go('/login');
  }

  void dispose() {
    locationCodeController.dispose();
    ipServerController.dispose();
  }
}