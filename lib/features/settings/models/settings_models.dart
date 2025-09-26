// lib/features/settings/models/settings_models.dart

class SettingsModel {
  // Simpan nama dan alamat printer
  String selectedPrinterName;
  String selectedPrinterAddress;

  String locationCode;
  String ipServer;
  String username;

  SettingsModel({
    this.selectedPrinterName = '',
    this.selectedPrinterAddress = '',
    this.locationCode = '',
    this.ipServer = '192.168.1.1',
    this.username = 'kasir_1',
  });
}