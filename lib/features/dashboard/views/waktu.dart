import 'package:flutter/material.dart';

class WaktuView extends StatelessWidget {
  const WaktuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 8,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo section at the top
          Center(
            child: Container(
              width: 230,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.image,
                size: 60,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Waktu Masuk
          _buildTimeItem(
            title: 'Waktu Masuk',
            time: '0000-00-00 00:00:00',
          ),
          const SizedBox(height: 20),

          // Waktu Scan
          _buildTimeItem(
            title: 'Waktu Scan',
            time: '0000-00-00 00:00:00',
          ),
          const SizedBox(height: 20),

          // Durasi
          _buildDurationItem(),
        ],
      ),
    );
  }

  Widget _buildTimeItem({required String title, required String time}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          time,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Durasi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          '-', // Placeholder untuk durasi
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}