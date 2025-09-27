// lib/features/dashboard/views/widgets/form_kendaraan.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controllers.dart';
import '../../models/vehicle_model.dart';

class FormKendaraan extends GetView<DashboardController> {
  const FormKendaraan({super.key});

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFF5A623);

    return Obx(() {
      final bool isActive = controller.isTransactionActive.value;
      final Color borderColor = isActive ? Colors.white54 : Colors.white12;
      final Color plateBgColor =
          isActive ? Colors.transparent : Colors.white10;

      final String fullPoliceNumber =
          '${controller.platePrefixController.text} ${controller.plateNumberController.text}'
              .trim();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Tampilan Plat Nomor Kondisional ---
                  if (isActive)
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: controller.platePrefixController,
                            readOnly: !isActive,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: isActive ? Colors.white : Colors.white54,
                                fontSize: 18),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: plateBgColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: borderColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.white)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: controller.plateNumberController,
                            readOnly: !isActive,
                            style: TextStyle(
                                color: isActive ? Colors.white : Colors.white54),
                            decoration: InputDecoration(
                              labelText: 'Nomor Plat',
                              labelStyle: TextStyle(
                                  color:
                                      isActive ? highlightColor : Colors.white24),
                              filled: true,
                              fillColor: plateBgColor,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: borderColor)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: TextEditingController(text: fullPoliceNumber),
                      readOnly: true,
                      style: const TextStyle(color: Colors.white54, fontSize: 18),
                      decoration: const InputDecoration(
                        labelText: 'Nomor Plat',
                        labelStyle: TextStyle(color: Colors.white24),
                        filled: true,
                        fillColor: Colors.white10,
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white12)),
                      ),
                    ),

                  const SizedBox(height: 24),
                  Text('Jenis Kendaraan',
                      style: TextStyle(
                          color: isActive ? highlightColor : Colors.white54,
                          fontSize: 16)),
                  const SizedBox(height: 12),
                  // --- GridView Dinamis ---
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: controller.vehicles.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final Vehicle vehicle = controller.vehicles[index];
                      return VehicleButton(
                        label: vehicle.name,
                        isSelected:
                            controller.selectedVehicleId.value == vehicle.vehicleId,
                        onTap: () => controller.changeVehicle(vehicle.vehicleId),
                        isActive: isActive,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total (Rp)',
                          style: TextStyle(
                              color: isActive ? highlightColor : Colors.white38,
                              fontSize: 18)),
                      Text(controller.formattedTotal,
                          style: TextStyle(
                              color: isActive ? Colors.white : Colors.white54,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: isActive ? controller.bayarCash : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A3A93),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text('BAYAR CASH',
                          style: TextStyle(fontSize: 16, color: Colors.white)))),
              const SizedBox(width: 16),
              Expanded(
                  child: ElevatedButton(
                      onPressed: isActive
                          ? () {
                              print('DEBUG: Tombol BAYAR QRIS di form_kendaraan.dart ditekan.');
                              controller.bayarQris(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text('BAYAR QRIS',
                          style: TextStyle(fontSize: 16, color: Colors.white)))),
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
    this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isActive
        ? (isSelected ? Colors.blueAccent : const Color(0xFF4A4E6A))
        : const Color(0xFF2C2F48);
    final Color textColor = isActive ? Colors.white : Colors.white38;

    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : Border.all(color: const Color(0xFF4A4E6A)),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
    );
  }
}