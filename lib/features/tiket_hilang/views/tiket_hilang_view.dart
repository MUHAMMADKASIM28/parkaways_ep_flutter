import 'package:flutter/material.dart';
import 'widgets/form_data_customer.dart'; // Path mungkin perlu disesuaikan
import 'widgets/form_detail_transaksi.dart';

class LostTicketView extends StatelessWidget {
  const LostTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D284D),
      appBar: AppBar(
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
                    // Card Form Customer
                    Expanded(
                      child: Card(
                        color: const Color(0xFF1A3E6E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomerDataForm(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Card Form Transaksi
                    Expanded(
                      child: Card(
                        color: const Color(0xFF1A3E6E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TransactionDetailsForm(),
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
                // Tombol Batal
                ElevatedButton(
                  onPressed: () {
                    print('Tombol Batal ditekan');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    // Diubah: Tambahkan shape untuk mengatur sudut
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('BATAL', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 16),
                // Tombol Simpan
                ElevatedButton(
                  onPressed: () {
                    print('Tombol Simpan Data ditekan');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    // Diubah: Tambahkan shape untuk mengatur sudut
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('SIMPAN DATA', style: TextStyle(color: Colors.yellow)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}