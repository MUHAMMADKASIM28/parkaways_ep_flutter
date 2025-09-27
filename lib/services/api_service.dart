// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../features/login/models/login_models.dart';
import '../features/login/models/location_model.dart';
import '../features/dashboard/models/transaction_model.dart';
import '../features/dashboard/models/vehicle_model.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final String baseUrl;

  ApiService({required String ipServer}) : baseUrl = 'http://$ipServer/api';

  Future<Map<String, dynamic>> generateQrCode({
    required String transactionCode,
    required int amount,
    required int locationId,
  }) async {
    final qrisBaseUrl = 'http://192.168.18.151:8080/api';
    final endpoint = 'xnd-bss-api/generate-qr';

    final body = {
      'reference_id': transactionCode,
      'amount': amount.toString(),
      'id_userlocations': locationId.toString(),
      'app_id': '2',
    };
    final headers = {
      'X-QR-SECRET': '@BctDev2025_05e6d6a1c09862372289b096edf96c30',
    };

    print('--- DEBUG: Memulai Permintaan QRIS ---');
    print('Endpoint: $qrisBaseUrl/$endpoint');
    print('Headers: $headers');
    print('Body: $body');

    final jsonResponse = await _postFormData(qrisBaseUrl, endpoint, body, headers: headers);

    // --- PERBAIKAN UTAMA DI SINI ---
    // Sesuaikan dengan struktur JSON dari dokumentasi API
    if (jsonResponse['status'] == 'success' && 
        jsonResponse['payment_method'] != null &&
        jsonResponse['payment_method']['qr_string'] != null) {
      
      print('Status SUKSES. Mengekstrak qr_string dari payment_method.');
      
      // Ambil data dari lokasi yang benar
      final paymentMethod = jsonResponse['payment_method'] as Map<String, dynamic>;
      final paymentRequest = jsonResponse['payment_request'] as Map<String, dynamic>;

      // Buat map baru yang lebih sederhana untuk dikirim ke UI
      return {
        'qr_string': paymentMethod['qr_string'],
        'reference_id': paymentRequest['reference_id'],
        // Anda bisa menambahkan data lain jika perlu, misalnya expires_at
        'expires_at': paymentMethod['expires_at'],
      };

    } else {
      print('Status GAGAL atau qr_string tidak ditemukan di dalam payment_method.');
      throw ApiException(jsonResponse['message'] ?? 'Gagal memuat data QR dari server');
    }
    // --- AKHIR PERBAIKAN ---
  }

  Future<Map<String, dynamic>> _postFormData(String customBaseUrl, String endpoint, Map<String, String> body, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse('$customBaseUrl/$endpoint');
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll(body);
      if (headers != null) {
        request.headers.addAll(headers);
      }
      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamedResponse);

      print('--- DEBUG: Respons Mentah dari Server QRIS ---');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
      print('--- AKHIR DARI RESPONS MENTAH ---');
      
      final responseBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan pada server.';
        throw ApiException('Error ${response.statusCode}: $errorMessage');
      }
    } on SocketException {
      throw ApiException('Tidak dapat terhubung ke server QRIS. Periksa koneksi dan IP Server.');
    } on TimeoutException {
      throw ApiException('Koneksi ke server QRIS timeout. Mohon coba lagi.');
    } catch (e) {
      print("ERROR SAAT DECODE JSON: Pastikan server QRIS tidak mengembalikan halaman error HTML.");
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // ... (Sisa kode tidak perlu diubah) ...
  
  Future<dynamic> _get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 10));
      final responseBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan pada server.';
        throw ApiException('Error ${response.statusCode}: $errorMessage');
      }
    } on SocketException {
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi dan IP Server.');
    } on TimeoutException {
      throw ApiException('Koneksi ke server timeout. Mohon coba lagi.');
    } catch (e) {
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      final responseBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan pada server.';
        throw ApiException('Error ${response.statusCode}: $errorMessage');
      }
    } on SocketException {
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi dan IP Server.');
    } on TimeoutException {
      throw ApiException('Koneksi ke server timeout. Mohon coba lagi.');
    } catch (e) {
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Location> getLocationDetails(int locationId) async {
    final jsonResponse = await _get('master/location/$locationId');
    return Location.fromJson(jsonResponse);
  }

  Future<List<Vehicle>> getVehicles() async {
    final jsonResponse = await _get('master/vehicle');
    final List<dynamic> vehicleList = jsonResponse as List<dynamic>;
    return vehicleList.map((json) => Vehicle.fromJson(json)).toList();
  }

  Future<LoginResponse> loginCashier({required String username, required String password}) async {
    final body = {'username': username, 'password': password};
    final jsonResponse = await _post('login/cashier', body);
    return LoginResponse.fromJson(jsonResponse);
  }

  Future<TransactionModel> checkTransaction({required String transactionCode}) async {
    final body = {'transaction_code': transactionCode};
    try {
      final uri = Uri.parse('$baseUrl/cektransaction');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      final responseBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return TransactionModel.fromJson(responseBody);
      } else {
        String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan pada server.';
        throw ApiException('Error ${response.statusCode}: $errorMessage');
      }
    } on SocketException {
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi dan IP Server.');
    } on TimeoutException {
      throw ApiException('Koneksi ke server timeout. Mohon coba lagi.');
    } catch (e) {
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> checkPrice({required String transactionCode, required int vehicleId, required String policeNumber}) async {
    final body = {
      'transaction_code': transactionCode,
      'vehicle_id': vehicleId,
      'police_number': policeNumber,
    };
    return await _post('cekprice', body);
  }

  Future<Map<String, dynamic>> updatePayment({
    required String transactionCode,
    required String policeNumber,
    required int shift,
    required int total,
    required int adminId,
    required String paymentType,
    required int vehicleId,
  }) async {
    final body = {
      'transaction_code': transactionCode,
      'police_number': policeNumber,
      'shift': shift,
      'total': total,
      'admin_id': adminId,
      'payment_type': paymentType,
      'vehicle_id': vehicleId,
    };
    
    print("===== DEBUG API: updatePayment =====");
    print("Endpoint: pepupdatepaymenttab");
    print("Body: ${jsonEncode(body)}");
    print("===================================");
    
    try {
      final uri = Uri.parse('$baseUrl/pepupdatepaymenttab');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      final responseBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan pada server.';
        throw ApiException('Error ${response.statusCode}: $errorMessage');
      }
    } on SocketException {
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi dan IP Server.');
    } on TimeoutException {
      throw ApiException('Koneksi ke server timeout. Mohon coba lagi.');
    } catch (e) {
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> processLostTicket({
    required int vehicleId,
    required String policeNumber,
    required int userId,
    required int shift,
    required String name,
    required String phone,
    required String ktp,
  }) async {
    final body = {
      'vehicle_id': vehicleId,
      'police_number': policeNumber,
      'user_id': userId,
      'shift': shift,
      'name': name,
      'phone': phone,
      'ktp': ktp,
    };
    return await _post('peplost', body);
  }
}