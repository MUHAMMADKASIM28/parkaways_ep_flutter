// lib/main.dart

import 'package:flutter/material.dart';
import 'route.dart'; // Impor file konfigurasi router

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan MaterialApp.router untuk mengintegrasikan go_router dengan aplikasi
    return MaterialApp.router(
      routerConfig: router, // Gunakan konfigurasi yang sudah dibuat
      debugShowCheckedModeBanner: false,
      title: 'Parkways Express Payment',
    );
  }
}