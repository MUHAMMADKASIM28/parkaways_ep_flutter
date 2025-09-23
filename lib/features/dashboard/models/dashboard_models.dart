// lib/features/dashboard/models/dashboard_models.dart

class TransactionData {
  final String transactionCode; // <-- TAMBAHKAN BARIS INI
  final String plateNumber;
  final String vehicleType;
  final DateTime entryTime;
  final DateTime scanTime;
  final int totalCost;

  TransactionData({
    required this.transactionCode, // <-- TAMBAHKAN BARIS INI
    required this.plateNumber,
    required this.vehicleType,
    required this.entryTime,
    required this.scanTime,
    required this.totalCost,
  });
}