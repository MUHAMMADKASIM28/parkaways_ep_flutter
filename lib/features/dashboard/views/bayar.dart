import 'package:flutter/material.dart';

class BayarView extends StatefulWidget {
  const BayarView({super.key});

  @override
  State<BayarView> createState() => _BayarViewState();
}

class _BayarViewState extends State<BayarView> {
  String selectedVehicleType = '';
  String kodePlat = 'DD';
  String nomorPlat = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF357ABD),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kode Plat dan Nomor Plat
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kode Plat',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFB366), // Orange color
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        kodePlat,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nomor Plat',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFB366), // Orange color
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        nomorPlat.isEmpty ? '' : nomorPlat,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pilih Jenis Kendaraan
          const Text(
            'Pilih Jenis Kendaraan',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFFFB366), // Orange color
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Vehicle Type Selection Grid
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildVehicleTypeCard('Motor', 'Motor'),
                    const SizedBox(height: 12),
                    _buildVehicleTypeCard('Motor - No Bill', 'Motor - No Bill'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _buildVehicleTypeCard('Mobil', 'Mobil'),
                    const SizedBox(height: 12),
                    _buildVehicleTypeCard('Mobil - No Bill', 'Mobil - No Bill'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Total
          const Text(
            'Total (Rp)',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFFFB366), // Orange color
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '0',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Spacer to push buttons to bottom
          const Spacer(),

          // Payment Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E88E5), // Blue color
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      'BAYAR CASH',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BCD4), // Cyan color
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      'BAYAR QRIS',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleTypeCard(String title, String value) {
    bool isSelected = selectedVehicleType == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedVehicleType = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.25)
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.5)
                : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}