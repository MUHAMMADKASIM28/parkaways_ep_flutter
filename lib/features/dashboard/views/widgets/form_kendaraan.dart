import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controllers.dart';

class FormKendaraan extends GetView<DashboardController> {
  const FormKendaraan({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isActive = controller.isTransactionActive.value;
      final Color borderColor = isActive ? Colors.white54 : Colors.white12;
      final Color labelColor = isActive ? Colors.white54 : Colors.white24;
      final Color plateBgColor = isActive ? Colors.transparent : Colors.white10;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(8),
                          color: plateBgColor,
                        ),
                        child: Text('DD', style: TextStyle(color: labelColor, fontSize: 18)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: controller.plateNumberController,
                          readOnly: true,
                          style: TextStyle(color: isActive ? Colors.white : Colors.white54),
                          decoration: InputDecoration(
                            labelText: 'Nomor Plat',
                            labelStyle: TextStyle(color: labelColor),
                            filled: true,
                            fillColor: plateBgColor,
                            disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Jenis Kendaraan', style: TextStyle(color: isActive ? Colors.white : Colors.white54, fontSize: 16)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      VehicleButton(label: 'Motor', isSelected: controller.selectedVehicle.value == 'Motor', onTap: null, isActive: isActive),
                      VehicleButton(label: 'Mobil', isSelected: controller.selectedVehicle.value == 'Mobil', onTap: null, isActive: isActive),
                      VehicleButton(label: 'Motor - No Bill', isSelected: controller.selectedVehicle.value == 'Motor - No Bill', onTap: null, isActive: isActive),
                      VehicleButton(label: 'Mobil - No Bill', isSelected: controller.selectedVehicle.value == 'Mobil - No Bill', onTap: null, isActive: isActive),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total (Rp)', style: TextStyle(color: isActive ? Colors.white70 : Colors.white38, fontSize: 18)),
                      Text('Rp ${controller.total.value}', style: TextStyle(color: isActive ? Colors.white : Colors.white54, fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: isActive ? controller.bayarCash : null, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A4E6A), padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text('BAYAR CASH', style: TextStyle(fontSize: 16)))),
              const SizedBox(width: 16),
              Expanded(child: ElevatedButton(onPressed: isActive ? controller.bayarQris : null, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A90E2), padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text('BAYAR QRIS', style: TextStyle(fontSize: 16)))),
            ],
          )
        ],
      );
    });
  }
}

class VehicleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isActive;

  const VehicleButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isActive
        ? (isSelected ? Colors.blueAccent : const Color(0xFF4A4E6A))
        : const Color(0xFF2C2F48);
    final Color textColor = isActive ? Colors.white : Colors.white38;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : Border.all(color: const Color(0xFF4A4E6A)),
        ),
        child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
    );
  }
}