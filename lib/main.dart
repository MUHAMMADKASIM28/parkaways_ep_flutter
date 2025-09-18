import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/dashboard/views/dashboard_view.dart'; // Sesuaikan path import ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Parkways Express Payment',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        brightness: Brightness.dark, // Mengatur tema gelap
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Opsional: Anda bisa menambahkan font custom
      ),
      
      // Mengatur halaman awal aplikasi
      initialRoute: '/',
      
      // Mendefinisikan semua halaman yang bisa diakses
      getPages: [
        GetPage(
          name: '/',
          page: () => const DashboardView(),
          binding: DashboardBinding(), // Menghubungkan View dengan Controller-nya
        ),
        // Anda bisa menambahkan halaman lain di sini nanti
        // GetPage(name: '/settings', page: () => SettingsScreen()),
      ],
    );
  }
}