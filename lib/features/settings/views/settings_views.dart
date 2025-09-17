// lib/features/settings/views/settings_view.dart

import 'package:flutter/material.dart';
import '../controllers/settings_controllers.dart';
import 'widgets/settings_group.dart';
import 'widgets/settings_item.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _controller = SettingsController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showPrinterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final List<String> printers = ['Default Printer', 'BluetoothPrinter'];

        return AlertDialog(
          title: const Text('Pilih Printer'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: printers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(printers[index]),
                  onTap: () {
                    setState(() {
                      _controller.selectPrinter(printers[index]);
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
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
                subtitle: _controller.settings.selectedPrinter,
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
                hintText: _controller.settings.locationCode,
                onButtonPressed: _controller.saveLocationCode,
              ),
              SettingItem(
                title: 'IP Server',
                subtitle: _controller.settings.ipServer,
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
                onButtonPressed: _controller.endSession,
                isLogoutButton: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}