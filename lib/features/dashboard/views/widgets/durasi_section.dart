import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controllers.dart';

class DurasiSection extends GetView<DashboardController> {
  const DurasiSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF4A4E6A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() {
              if (controller.vehicleImageUrl.value.isEmpty) {
                return const Icon(Icons.image_outlined, color: Colors.white38, size: 50);
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    controller.vehicleImageUrl.value,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback jika gambar gagal dimuat
                      return const Icon(Icons.broken_image_outlined, color: Colors.white38, size: 50);
                    },
                  ),
                );
              }
            }),
          ),
        ),
        const SizedBox(height: 24),
        Obx(() => InfoText(label: 'Waktu Masuk', value: controller.waktuMasuk.value)),
        Obx(() => InfoText(label: 'Waktu Scan', value: controller.waktuScan.value)),
        Obx(() => InfoText(label: 'Durasi', value: controller.durasi.value)),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  final String label;
  final String value;
  const InfoText({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}