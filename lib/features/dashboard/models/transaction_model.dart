// lib/features/dashboard/models/transaction_model.dart

class TransactionModel {
  final String status;
  final String statusTiket;
  final String transactionCode;
  final String waktuMasuk;
  final String waktuScan;
  final String durasi;
  final String camIn;
  final String policeNumber;
  final String vehicleId;
  final String total;

  TransactionModel({
    required this.status,
    required this.statusTiket,
    required this.transactionCode,
    required this.waktuMasuk,
    required this.waktuScan,
    required this.durasi,
    required this.camIn,
    required this.policeNumber,
    required this.vehicleId,
    required this.total,
  });

  // --- PERBAIKAN UTAMA DI SINI ---
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    // Helper function untuk mengubah nilai apa pun (int, String, null) menjadi String
    String _parseToString(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return TransactionModel(
      status: json['status'] as String? ?? 'error',
      statusTiket: json['status_tiket'] as String? ?? '-',
      transactionCode: json['transaction_code'] as String? ?? '-',
      waktuMasuk: json['waktu_masuk'] as String? ?? '-',
      waktuScan: json['waktu_scan'] as String? ?? '-',
      durasi: json['durasi'] as String? ?? '-',
      camIn: json['cam_in'] as String? ?? '',
      policeNumber: json['police_number'] as String? ?? '-',
      
      // Menggunakan helper function yang aman
      vehicleId: _parseToString(json['vehicle_id']),
      total: _parseToString(json['total']),
    );
  }
}