// lib/features/qris/views/qris_payment_view.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:parkaways_ep_flutter/features/dashboard/controllers/dashboard_controllers.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrisPaymentView extends StatefulWidget {
  final Map<String, dynamic> paymentData;

  const QrisPaymentView({super.key, required this.paymentData});

  @override
  State<QrisPaymentView> createState() => _QrisPaymentViewState();
}

class _QrisPaymentViewState extends State<QrisPaymentView> {
  final DashboardController dashboardController = Get.find<DashboardController>();
  bool _isConfirming = false;

  Timer? _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    final qrData = widget.paymentData['qrData'] as Map<String, dynamic>?;
    final expiresAtString = qrData?['expires_at'] as String?;

    if (expiresAtString != null) {
      try {
        final expiresAt = DateTime.parse(expiresAtString).toLocal();
        
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          final now = DateTime.now();
          final difference = expiresAt.difference(now);

          if (difference.isNegative) {
            setState(() {
              _remainingTime = Duration.zero;
            });
            timer.cancel();
          } else {
            setState(() {
              _remainingTime = difference;
            });
          }
        });
      } catch (e) {
        print("Error parsing expires_at: $e");
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _confirmPayment() async {
    setState(() {
      _isConfirming = true;
    });
    await dashboardController.handlePayment('qris', context);
    if (mounted) {
      setState(() {
        _isConfirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String noPlat = widget.paymentData['fullPoliceNumber'] ?? '-';
    final String kendaraan = widget.paymentData['vehicleName'] ?? '-';
    final String waktuMasuk = widget.paymentData['transaction']?.waktuMasuk ?? '-';
    final String waktuScan = widget.paymentData['transaction']?.waktuScan ?? '-';
    final int total = widget.paymentData['total'] ?? 0;
    
    final qrData = widget.paymentData['qrData'] as Map<String, dynamic>?;
    final String qrString = qrData?['qr_string'] as String? ?? '';
    final String referenceId = qrData?['reference_id'] as String? ?? '-';

    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E3F),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          // --- PERUBAHAN UTAMA DI SINI ---
          onPressed: () {
            // 1. Bersihkan data transaksi yang ada di controller dashboard
            dashboardController.clearTransaction();
            // 2. Arahkan pengguna kembali ke halaman dashboard
            context.go('/dashboard');
          },
          // --- AKHIR PERUBAHAN ---
        ),
        title: const Text('Pembayaran QRIS', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 350,
                  child: Card(
                    color: const Color(0xFF2C2F48),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('No. Plat', noPlat),
                          const SizedBox(height: 8),
                          _buildDetailRow('Kendaraan', kendaraan),
                          const SizedBox(height: 24),
                          _buildDetailRow('Waktu Masuk', waktuMasuk),
                          const SizedBox(height: 8),
                          _buildDetailRow('Waktu Scan', waktuScan),
                          const SizedBox(height: 24),
                          _buildDetailRow('Total', currencyFormatter.format(total)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.asset('assets/icons/logo-qris.png', height: 40),
                        const SizedBox(height: 16),
                        if (qrString.isNotEmpty)
                          QrImageView(
                            data: qrString,
                            version: QrVersions.auto,
                            size: 250.0,
                          )
                        else
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                                  const SizedBox(height: 10),
                                  const Text('Gagal Memuat QR Code', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text('NMID: ID$referenceId', style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _remainingTime.inSeconds > 0 ? Icons.timer_outlined : Icons.timer_off_outlined,
                              color: _remainingTime.inSeconds > 0 ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _remainingTime.inSeconds > 0 ? 'Berakhir dalam ${_formatDuration(_remainingTime)}' : 'Telah Kedaluwarsa',
                              style: TextStyle(
                                fontSize: 14,
                                color: _remainingTime.inSeconds > 0 ? Colors.black : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: (_isConfirming || _remainingTime.inSeconds <= 0) ? null : _confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isConfirming
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('KONFIRMASI BAYAR', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}