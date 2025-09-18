// form_kendaraan.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controllers.dart';

class FormKendaraan extends GetView<DashboardController> {
  const FormKendaraan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bagian Input Plat
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('DD', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: controller.plateNumberController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nomor Plat',
                  labelStyle: const TextStyle(color: Colors.white54),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Bagian Pilih Kendaraan
        const Text('Pilih Jenis Kendaraan', style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 12),
        
        Obx(() => GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            VehicleButton(label: 'Motor', isSelected: controller.selectedVehicle.value == 'Motor', onTap: () => controller.selectVehicle('Motor')),
            VehicleButton(label: 'Mobil', isSelected: controller.selectedVehicle.value == 'Mobil', onTap: () => controller.selectVehicle('Mobil')),
            VehicleButton(label: 'Motor - No Bill', isSelected: controller.selectedVehicle.value == 'Motor - No Bill', onTap: () => controller.selectVehicle('Motor - No Bill')),
            VehicleButton(label: 'Mobil - No Bill', isSelected: controller.selectedVehicle.value == 'Mobil - No Bill', onTap: () => controller.selectVehicle('Mobil - No Bill')),
          ],
        )),
        
        // DIUBAH: Hapus Spacer() dari sini untuk menghilangkan konflik layout
        // const Spacer(),
        const SizedBox(height: 24), // Ganti Spacer dengan SizedBox untuk spasi statis

        // Bagian Total
        const Divider(color: Colors.white24),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total (Rp)', style: TextStyle(color: Colors.white70, fontSize: 18)),
            Obx(() => Text('${controller.total.value}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 24),

        // Bagian Tombol Bayar
        Row(
          children: [
            Expanded(child: ElevatedButton(onPressed: controller.bayarCash, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A4E6A), padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text('BAYAR CASH', style: TextStyle(fontSize: 16)))),
            const SizedBox(width: 16),
            Expanded(child: ElevatedButton(onPressed: controller.bayarQris, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A90E2), padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text('BAYAR QRIS', style: TextStyle(fontSize: 16)))),
          ],
        )
      ],
    );
  }
}

// ... (Widget VehicleButton tidak perlu diubah) ...
class VehicleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : const Color(0xFF4A4E6A),
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}