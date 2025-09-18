class TransactionData {
  final String plateNumber;
  final String vehicleType;
  final DateTime entryTime;
  final DateTime scanTime;
  final int totalCost;

  TransactionData({
    required this.plateNumber,
    required this.vehicleType,
    required this.entryTime,
    required this.scanTime,
    required this.totalCost,
  });
}