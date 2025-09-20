// lib/features/settings/controllers/settings_controller.dart

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
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

  // Fungsi ini menerima objek BluetoothDevice
  void selectPrinter(BluetoothDevice device) {
    settings.selectedPrinterName = device.name ?? 'Unknown Device';
    settings.selectedPrinterAddress = device.address ?? '';

    // Langsung coba hubungkan ke printer yang dipilih
    BlueThermalPrinter.instance.connect(device).then((isConnected) {
      if (isConnected == true) {
        Fluttertoast.showToast(msg: 'Terhubung ke: ${settings.selectedPrinterName}');
      } else {
        Fluttertoast.showToast(msg: 'Gagal terhubung ke printer', backgroundColor: Colors.red);
      }
    });
  }

  void saveLocationCode() {
    settings.locationCode = locationCodeController.text;
    Fluttertoast.showToast(msg: 'Kode Plat berhasil disimpan!');
  }

  void saveIpServer() {
    settings.ipServer = ipServerController.text;
    Fluttertoast.showToast(msg: 'IP Server berhasil disimpan!');
  }

  void endSession(BuildContext context) {
    context.go('/login');
  }

  void dispose() {
    locationCodeController.dispose();
    ipServerController.dispose();
  }
}