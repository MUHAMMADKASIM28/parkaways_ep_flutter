// lib/features/dashboard/views/widgets/header_section.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFF5A623);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'Parkways Express Payment - BSS Office',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.go('/lost-ticket');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('TIKET HILANG', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 24),
              const Text('Selamat Bekerja\nkasir_1', textAlign: TextAlign.right, style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.settings, color: highlightColor, size: 28),
                onPressed: () {
                  context.go('/settings');
                },
                tooltip: 'Pengaturan',
              ),
            ],
          ),
        ],
      ),
    );
  }
}