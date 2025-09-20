// lib/features/settings/views/settings_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controllers/settings_controllers.dart';
import 'widgets/settings_group.dart';
import 'widgets/settings_item.dart';
// DIUBAH: Perbaiki cara impor package di sini
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _controller = SettingsController();
  List<BluetoothDevice> _devices = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getBluetoothDevices();
  }

  void _getBluetoothDevices() async {
    setState(() => _isLoading = true);
    try {
      _devices = await BlueThermalPrinter.instance.getBondedDevices();
    } catch (e) {
      print("Error getting devices: $e");
    }
    setState(() => _isLoading = false);
  }

  void _showPrinterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Printer Bluetooth'),
          content: SizedBox(
            width: double.minPositive,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              shrinkWrap: true,
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown Device'),
                  subtitle: Text(device.address ?? ''),
                  onTap: () {
                    setState(() {
                      _controller.selectPrinter(device);
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: _getBluetoothDevices,
              child: const Text('REFRESH'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/dashboard'),
        ),
        title: const Text('Pengaturan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SettingGroup(
            title: 'PERANGKAT',
            children: [
              SettingItem(
                title: 'Printer',
                subtitle: _controller.settings.selectedPrinterName.isNotEmpty
                    ? _controller.settings.selectedPrinterName
                    : 'Belum ada printer terpilih',
                buttonText: 'Atur Printer',
                onButtonPressed: _showPrinterDialog,
              ),
            ],
          ),
          SettingGroup(
            title: 'KONEKSI & LOKASI',
            children: [
              SettingItem(
                title: 'Masukkan Kode Plat',
                buttonText: 'Simpan',
                textFieldController: _controller.locationCodeController,
                onButtonPressed: _controller.saveLocationCode,
              ),
              SettingItem(
                title: 'IP Server',
                buttonText: 'Simpan',
                textFieldController: _controller.ipServerController,
                onButtonPressed: _controller.saveIpServer,
              ),
            ],
          ),
          SettingGroup(
            title: 'AKUN',
            children: [
              SettingItem(
                title: 'User Login',
                subtitle: _controller.settings.username,
                buttonText: 'Akhiri Sesi',
                onButtonPressed: () => _controller.endSession(context),
                isLogoutButton: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}