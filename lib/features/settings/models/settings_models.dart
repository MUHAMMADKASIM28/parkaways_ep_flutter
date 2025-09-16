// lib/features/settings/models/settings_model.dart

class SettingsModel {
  String selectedPrinter;
  String locationCode;
  String ipServer;
  String username;

  SettingsModel({
    this.selectedPrinter = 'BluetoothPrinter',
    this.locationCode = '',
    this.ipServer = '192.168.1.1',
    this.username = 'kasir_1',
  });
}