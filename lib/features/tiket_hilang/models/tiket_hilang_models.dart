class LostTicketModel {
  String customerName;
  String phoneNumber;
  String idNumber;
  String postalCode;
  String licensePlate;
  String? vehicleType;
  int totalFee;

  LostTicketModel({
    this.customerName = '',
    this.phoneNumber = '',
    this.idNumber = '',
    this.postalCode = '',
    this.licensePlate = '',
    this.vehicleType,
    this.totalFee = 0,
  });
}