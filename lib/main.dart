// import 'package:flutter/material.dart';
// import 'features/tiket_hilang/views/tiket_hilang_view.dart'; 

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Aplikasi Parkir',
//       debugShowCheckedModeBanner: false, // Menghilangkan banner "Debug"
//       theme: ThemeData(
//         brightness: Brightness.dark, // Mengatur tema gelap secara global
//         fontFamily: 'Poppins', // Contoh jika ingin menggunakan font kustom
//       ),
//       // 2. Ganti halaman utama dengan LostTicketScreen
//       home: const LostTicketView(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/dashboard/views/dashboard_view.dart'; // Sesuaikan path import ini
import 'features/settings/views/settings_views.dart'; 

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