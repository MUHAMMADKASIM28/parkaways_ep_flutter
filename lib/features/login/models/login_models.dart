// lib/features/login/models/login_models.dart

class LoginResponse {
  final String status;
  final int userId;

  LoginResponse({
    required this.status,
    required this.userId,
  });

  // --- DIUBAH TOTAL: Cara parsing JSON menjadi lebih aman ---
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Siapkan nilai default
    int parsedUserId = 0;
    final dynamic userIdValue = json['user_id'];

    // Cek tipe data dari user_id
    if (userIdValue is int) {
      // Jika sudah int, langsung gunakan
      parsedUserId = userIdValue;
    } else if (userIdValue is String) {
      // Jika berupa String, coba ubah menjadi int
      // Jika gagal (misal: string kosong), akan menjadi 0
      parsedUserId = int.tryParse(userIdValue) ?? 0;
    }

    return LoginResponse(
      status: json['status'] as String? ?? 'Gagal Login',
      userId: parsedUserId, // Gunakan nilai yang sudah aman untuk diparsing
    );
  }
}