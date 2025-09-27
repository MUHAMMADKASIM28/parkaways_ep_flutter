// lib/features/login/models/location_model.dart

class Location {
  final int locationId;
  final String name;
  final String locationCode;
  final String image;
  final String idUserlocations; // <-- BARIS INI DITAMBAHKAN

  Location({
    required this.locationId,
    required this.name,
    required this.locationCode,
    required this.image,
    required this.idUserlocations, // <-- BARIS INI DITAMBAHKAN
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['location_id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Lokasi Tidak Dikenal',
      locationCode: json['location_code'] as String? ?? '',
      image: json['image'] as String? ?? '',
      // --- PERUBAHAN DI SINI ---
      // Membaca 'id_userlocations' dari JSON.
      // Jika null atau tidak ada, default-nya adalah string kosong '0'.
      idUserlocations: json['id_userlocations'] as String? ?? '0',
    );
  }
}