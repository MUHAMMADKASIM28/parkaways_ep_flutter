import 'package:flutter/material.dart';
import 'features/tiket_hilang/views/tiket_hilang_view.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Parkir',
      debugShowCheckedModeBanner: false, // Menghilangkan banner "Debug"
      theme: ThemeData(
        brightness: Brightness.dark, // Mengatur tema gelap secara global
        fontFamily: 'Poppins', // Contoh jika ingin menggunakan font kustom
      ),
      // 2. Ganti halaman utama dengan LostTicketScreen
      home: const LostTicketView(),
    );
  }
}