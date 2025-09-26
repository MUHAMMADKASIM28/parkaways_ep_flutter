// lib/features/dashboard/models/vehicle_model.dart

class Vehicle {
  final int vehicleId;
  final String name;
  final bool actived;
  final String type;

  Vehicle({
    required this.vehicleId,
    required this.name,
    required this.actived,
    required this.type,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicle_id'] as int,
      name: json['name'] as String,
      actived: (json['actived'] as String).toLowerCase() == 'true',
      type: json['type'] as String,
    );
  }
}