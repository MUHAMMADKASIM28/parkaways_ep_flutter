// lib/features/settings/controllers/settings_controller.dart

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../models/settings_models.dart';
import '../../../services/secure_storage_service.dart'; // Impor secure storage service

class SettingsController {
  var settings = SettingsModel();
  late TextEditingController locationCodeController;
  late TextEditingController ipServerController;
  final SecureStorageService _storageService = SecureStorageService(); // Buat instance service

  SettingsController() {
    locationCodeController = TextEditingController();
    ipServerController = TextEditingController();
    _loadSettings();
  }

  // Fungsi untuk memuat pengaturan dari storage
  Future<void> _loadSettings() async {
    settings.selectedPrinterName = await _storageService.read('printerName') ?? '';
    settings.selectedPrinterAddress = await _storageService.read('printerAddress') ?? '';
    settings.locationCode = await _storageService.read('locationCode') ?? '';
    settings.ipServer = await _storageService.read('ipServer') ?? '192.168.100.5';
    settings.username = await _storageService.read('username') ?? 'kasir_utama';

    locationCodeController.text = settings.locationCode;
    ipServerController.text = settings.ipServer;
  }

  void selectPrinter(BluetoothDevice device) async {
    settings.selectedPrinterName = device.name ?? 'Unknown Device';
    settings.selectedPrinterAddress = device.address ?? '';

    // Simpan data printer
    await _storageService.write('printerName', settings.selectedPrinterName);
    await _storageService.write('printerAddress', settings.selectedPrinterAddress);

    BlueThermalPrinter.instance.connect(device).then((isConnected) {
      if (isConnected == true) {
        Fluttertoast.showToast(msg: 'Terhubung ke: ${settings.selectedPrinterName}');
      } else {
        Fluttertoast.showToast(msg: 'Gagal terhubung ke printer', backgroundColor: Colors.red);
      }
    });
  }

  void saveLocationCode() async {
    settings.locationCode = locationCodeController.text;
    await _storageService.write('locationCode', settings.locationCode);
    Fluttertoast.showToast(msg: 'Kode Plat berhasil disimpan!');
  }

  void saveIpServer() async {
    settings.ipServer = ipServerController.text;
    await _storageService.write('ipServer', settings.ipServer);
    Fluttertoast.showToast(msg: 'IP Server berhasil disimpan!');
  }

  void endSession(BuildContext context) async {
    // Hapus data sesi dari storage
    await _storageService.delete('userId');
    await _storageService.delete('shift');
    await _storageService.delete('username');
    context.go('/login');
  }

  void dispose() {
    locationCodeController.dispose();
    ipServerController.dispose();
  }
}