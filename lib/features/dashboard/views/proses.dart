import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/dashboard_controllers.dart';

class ProsesView extends StatefulWidget {
  final DashboardController controller;

  const ProsesView({super.key, required this.controller});

  @override
  State<ProsesView> createState() => _ProsesViewState();
}

class _ProsesViewState extends State<ProsesView> {
  CameraController? _cameraController;
  final List<CameraDescription> _cameras = [];
  final TextEditingController _ticketCodeController = TextEditingController();
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _ticketCodeController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras.addAll(await availableCameras());
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } on CameraException catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _processTransaction() {
    if (_ticketCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kode tiket terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaksi berhasil untuk kode: ${_ticketCodeController.text}')),
        );
        _ticketCodeController.clear();
      }
    });
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return CameraPreview(_cameraController!);
  }

  Widget _buildScanOverlay() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomPaint(
          painter: _ScanOverlayPainter(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF001F3F),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Rapat ke kiri
          children: [
            // Camera Preview dengan width fixed
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // Radius untuk lengkungan sudut
              child: Container(
                height: 500, // Tinggi camera
                width: 300,   // Lebar camera
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildCameraPreview(),
                    _buildScanOverlay(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Input Field dengan lebar mengikuti camera
            Container(
              width: 300, // Sama dengan lebar camera
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _ticketCodeController,
                decoration: InputDecoration(
                  labelText: 'Scan tiket atau masukkan kode tiket',
                  labelStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Process Button dengan lebar mengikuti camera
            SizedBox(
              width: 300, // Sama dengan lebar camera
              height: 45,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isProcessing ? Colors.grey : Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'PROSES TRANSAKSI',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final cornerLength = 15.0;

    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);

    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}