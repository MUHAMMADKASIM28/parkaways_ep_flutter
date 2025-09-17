import 'package:flutter/material.dart';
import 'features/settings/views/settings_views.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengaturan App',
      // Menghilangkan banner "Debug" di pojok kanan atas
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 2. Jadikan SettingsView sebagai halaman utama
      home: const SettingsView(), 
    );
  }
}