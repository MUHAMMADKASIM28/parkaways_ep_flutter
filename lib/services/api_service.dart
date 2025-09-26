// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../features/login/models/login_models.dart';
import '../features/login/models/location_model.dart';
import '../features/dashboard/models/transaction_model.dart';
import '../features/dashboard/models/vehicle_model.dart'; // <-- Ditambahkan

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final String baseUrl;

  ApiService({required String ipServer}) : baseUrl = 'http://$ipServer/api';

  Future<dynamic> _get(String endpoint) async { // <-- Diubah menjadi dynamic
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

  Future<Location> getLocationDetails(int locationId) async {
    final jsonResponse = await _get('master/location/$locationId');
    return Location.fromJson(jsonResponse);
  }

  // --- FUNGSI BARU UNTUK MENGAMBIL DAFTAR KENDARAAN ---
  Future<List<Vehicle>> getVehicles() async {
    final jsonResponse = await _get('master/vehicle');
    final List<dynamic> vehicleList = jsonResponse as List<dynamic>;
    return vehicleList.map((json) => Vehicle.fromJson(json)).toList();
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

  Future<LoginResponse> loginCashier({required String username, required String password}) async {
    final body = {
      'username': username,
      'password': password,
    };
    final jsonResponse = await _post('login/cashier', body);
    return LoginResponse.fromJson(jsonResponse);
  }

  Future<TransactionModel> checkTransaction({required String transactionCode}) async {
    final body = {
      'transaction_code': transactionCode,
    };

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