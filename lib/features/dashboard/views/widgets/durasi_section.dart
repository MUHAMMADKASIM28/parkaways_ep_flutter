// durasi_section.dart
import 'package:flutter/material.dart';

class DurasiSection extends StatelessWidget {
  const DurasiSection({super.key});

  @override
  Widget build(BuildContext context) {
    // DIUBAH: Ganti SingleChildScrollView kembali menjadi Column
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DIUBAH: Ubah aspectRatio menjadi 16/9 untuk persegi panjang
        AspectRatio(
          aspectRatio: 16 / 9, // Rasio widescreen, membuatnya persegi panjang
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF4A4E6A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image_outlined, color: Colors.white38, size: 50),
          ),
        ),
        const SizedBox(height: 24),

        // Detail Waktu (tidak berubah)
        const InfoText(label: 'Waktu Masuk', value: '0000-00-00 00:00:00'),
        const InfoText(label: 'Waktu Scan', value: '0000-00-00 00:00:00'),
        const InfoText(label: 'Durasi', value: '-'),
      ],
    );
  }
}

// Widget bantu untuk teks info (tidak ada perubahan)
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
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}