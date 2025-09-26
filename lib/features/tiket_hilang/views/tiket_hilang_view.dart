// features/tiket_hilang/views/tiket_hilang_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controllers/tiket_hilang_controllers.dart';
import 'widgets/form_data_customer.dart';
import 'widgets/form_detail_transaksi.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LostTicketView extends StatefulWidget {
  const LostTicketView({super.key});

  @override
  State<LostTicketView> createState() => _LostTicketViewState();
}

class _LostTicketViewState extends State<LostTicketView> {
  final _controller = LostTicketController();
  // BARU: State untuk mengelola status loading saat API dipanggil
  bool _isLoading = false;

  void _onVehicleSelected(String vehicleName) {
    setState(() {
      _controller.selectVehicle(vehicleName);
    });
  }

  // FUNGSI UNTUK MENANGANI LOGIKA PENYIMPANAN
  Future<void> _saveData() async {
    // 1. Set state loading menjadi true dan rebuild UI
    setState(() {
      _isLoading = true;
    });

    // 2. Panggil controller dan TUNGGU hasilnya dengan 'await'
    final String? errorMessage = await _controller.saveTicket();

    // 3. Setelah selesai, set state loading kembali ke false
    setState(() {
      _isLoading = false;
    });

    // 4. Proses hasilnya
    if (mounted) { // Cek apakah widget masih ada di tree
      if (errorMessage != null) {
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Tampilkan dialog konfirmasi setelah berhasil
        showDialog(
          context: context,
          barrierDismissible: false, // Mencegah dialog ditutup dengan tap di luar
          builder: (BuildContext dialogContext) { // Gunakan context baru untuk dialog
            return AlertDialog(
              title: const Text('Simpan Berhasil'),
              content: const Text('Data tiket hilang telah berhasil disimpan. Apakah Anda ingin mencetak struk?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Tidak'),
                  onPressed: () {
                    context.go('/dashboard'); // Kembali ke dashboard
                  },
                ),
                TextButton(
                  child: const Text('Ya, Cetak'),
                  onPressed: () {
                    // Kirim 'context' dari view ke controller
                    _controller.printLostTicketReceipt(context);
                    context.go('/dashboard'); // Kembali ke dashboard
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E3F),
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/dashboard');
          },
        ),
        title: const Text('Tiket Hilang'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Card(
                        color: const Color(0xFF2C2F48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomerDataForm(controller: _controller),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        color: const Color(0xFF2C2F48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TransactionDetailsForm(
                            controller: _controller,
                            onVehicleSelected: _onVehicleSelected,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : () => context.go('/dashboard'), // Nonaktifkan saat loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(251, 192, 45, 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Text('BATAL',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  // Panggil fungsi _saveData yang sudah async
                  // Nonaktifkan tombol jika sedang loading
                  onPressed: _isLoading ? null : _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  // Tampilkan indikator loading atau teks
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text('SIMPAN DATA',
                          style: TextStyle(
                            color: Color.fromRGBO(251, 192, 45, 1),
                            fontWeight: FontWeight.bold,
                          )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}