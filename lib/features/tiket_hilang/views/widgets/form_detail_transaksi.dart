import 'package:flutter/material.dart';
import '../../controllers/tiket_hilang_controllers.dart';
import 'custom_text_field.dart';
import 'core/utils/formatters.dart';

class TransactionDetailsForm extends StatelessWidget {
  final LostTicketController controller;
  final Function(String) onVehicleSelected;

  const TransactionDetailsForm({
    super.key,
    required this.controller,
    required this.onVehicleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaksi Tiket Hilang',
          style: TextStyle(color: Color.fromRGBO(251, 192, 45, 1), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Diubah: Tambahkan flex dengan nilai lebih kecil
            Expanded(
              flex: 1, 
              child: CustomTextField(label: 'Kode Plat', controller: controller.platCodeController),
            ),
            const SizedBox(width: 16),
            // Diubah: Tambahkan flex dengan nilai lebih besar
            Expanded(
              flex: 4,
              child: CustomTextField(label: 'Nomor Plat', controller: controller.licensePlateController),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Pilih jenis kendaraan', style: TextStyle(color: Color.fromRGBO(251, 192, 45, 1))),
        const SizedBox(height: 8),
        Column(
          children: [
            Row(
              children: [
                _buildVehicleOptionBox('Motor'),
                const SizedBox(width: 10),
                _buildVehicleOptionBox('Mobil'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildVehicleOptionBox('Mobil A'),
                const SizedBox(width: 10),
                _buildVehicleOptionBox('Mobil B'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Total Biaya
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Total (Rp)',
              style: TextStyle(color: Color.fromRGBO(251, 192, 45, 1), fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Rp. ${AppFormatters.currency.format(controller.ticket.totalFee)}',
              textAlign: TextAlign.left, 
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildVehicleOptionBox(String vehicleName) {
    bool isSelected = controller.ticket.vehicleType == vehicleName;

    return Expanded(
      child: GestureDetector(
        onTap: () => onVehicleSelected(vehicleName),
        child: AspectRatio(
          aspectRatio: 8,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Color.fromRGBO(251, 192, 45, 1) : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: isSelected ? Border.all(color: Colors.white, width: 1.5) : null,
            ),
            child: Center(
              child: Text(
                vehicleName,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}