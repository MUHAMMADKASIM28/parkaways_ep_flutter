// lib/features/login/models/location_model.dart

class Location {
  final int locationId;
  final String name;
  final String locationCode;
  final String image;

  Location({
    required this.locationId,
    required this.name,
    required this.locationCode,
    required this.image,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['location_id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Lokasi Tidak Dikenal',
      locationCode: json['location_code'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}