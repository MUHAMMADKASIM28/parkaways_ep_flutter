class LostTicketModel {
  String customerName;
  String phoneNumber;
  String idNumber;
  String platCode;
  String licensePlate;
  String? vehicleType;
  int totalFee;

  LostTicketModel({
    this.customerName = '',
    this.phoneNumber = '',
    this.idNumber = '',
    this.platCode = '',
    this.licensePlate = '',
    this.vehicleType,
    this.totalFee = 0,
  });
}