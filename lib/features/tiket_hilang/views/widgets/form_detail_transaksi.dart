// lib/widgets/transaction_details_form.dart

import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class TransactionDetailsForm extends StatefulWidget {
  const TransactionDetailsForm({super.key});

  @override
  State<TransactionDetailsForm> createState() => _TransactionDetailsFormState();
}

class _TransactionDetailsFormState extends State<TransactionDetailsForm> {
  // 1. Ubah menjadi nullable (String?) dan hapus nilai awal.
  String? _selectedVehicle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaksi Tiket Hilang',
          style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Baris Kode Plat dan Nomor Plat
        const Row(
          children: [
            Expanded(child: CustomTextField(label: 'Kode Plat')),
            SizedBox(width: 16),
            Expanded(child: CustomTextField(label: 'Nomor Plat')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Pilih jenis kendaraan', style: TextStyle(color: Colors.yellow)),
        const SizedBox(height: 8),
        Column(
          children: [
            // Baris Atas
            Row(
              children: [
                _buildVehicleOptionBox('Motor'),
                const SizedBox(width: 10),
                _buildVehicleOptionBox('Mobil'),
              ],
            ),
            const SizedBox(height: 10),
            // Baris Bawah
            Row(
              children: [
                _buildVehicleOptionBox('Motor - No Bill'),
                const SizedBox(width: 10),
                _buildVehicleOptionBox('Mobil - No Bill'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Total Biaya
        const Column(
          children: [
            Text('Total (Rp)', style: TextStyle(color: Colors.yellow, fontSize: 16)),
            SizedBox(height: 2),
            Text('Rp. 0', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget _buildVehicleOptionBox(String vehicleName) {
    // Logika ini tetap berfungsi dengan benar
    bool isSelected = _selectedVehicle == vehicleName;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedVehicle = vehicleName;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.yellowAccent : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: Colors.white, width: 1.5) : null,
          ),
          child: Center(
            child: Text(
              vehicleName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}