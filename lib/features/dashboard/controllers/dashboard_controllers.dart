import 'package:flutter/material.dart';

class DashboardController {
  void handleSettings(BuildContext context) {
    // Handle settings button click
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengaturan diklik')),
    );
  }

  void handleLostTicket(BuildContext context) {
    // Handle lost ticket button click
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tiket Hilang diklik')),
    );
  }
}