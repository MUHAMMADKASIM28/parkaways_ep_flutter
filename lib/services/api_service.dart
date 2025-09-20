// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // GANTI DENGAN ALAMAT IP SERVER ANDA
  // Pilih salah satu dan hapus komentar, sesuaikan dengan kebutuhan.

  // 1. Jika server ada di internet (production)
  static const String _baseUrl = 'http://203.0.113.55/api'; // <-- Ganti IP publik server

  // 2. Jika server berjalan di komputer yang sama dengan Android Emulator
  // static const String _baseUrl = 'http://10.0.2.2:8000/api'; // Port 8000 adalah contoh

  // 3. Jika server di komputer yang sama & tes di HP fisik (terhubung ke WiFi yang sama)
  // static const String _baseUrl = 'http://192.168.1.10/api'; // <-- Ganti IP lokal komputer

  /// Mengambil detail tiket dari server berdasarkan kode tiket.
  Future<Map<String, dynamic>> getTicketDetails(String ticketCode) async {
    try {
      final uri = Uri.parse('$_baseUrl/tickets/$ticketCode');

      // Kirim permintaan GET ke server, dengan batas waktu 5 detik
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Jika berhasil (kode 200 OK), decode response body dari JSON ke Map
        return jsonDecode(response.body);
      } else {
        // Jika server merespons dengan error (misal: 404 Not Found)
        throw Exception('Tiket tidak ditemukan atau server error. Status: ${response.statusCode}');
      }
    } catch (e) {
      // Menangani semua jenis error (koneksi, timeout, format, dll)
      throw Exception('Gagal terhubung ke server: ${e.toString()}');
    }
  }

// Anda bisa menambahkan fungsi lain di sini, misalnya:
// Future<void> postLostTicket(Map<String, dynamic> data) async { ... }
// Future<bool> loginUser(String username, String password) async { ... }
}