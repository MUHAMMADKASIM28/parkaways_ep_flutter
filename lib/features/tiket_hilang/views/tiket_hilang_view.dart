import 'package:flutter/material.dart';
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

  void _onVehicleSelected(String vehicleName) {
    setState(() {
      _controller.selectVehicle(vehicleName);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                    Expanded(
                      child: Card(
                        color: const Color(0xFF1A3E6E),
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
                        color: const Color(0xFF1A3E6E),
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
                  onPressed: () {
                    setState(() {
                      _controller.clearForm();
                    });
                  },
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
                  onPressed: () {
                    final errorMessage = _controller.saveTicket();

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
                      Fluttertoast.showToast(msg: "Data Berhasil Disimpan!");
                      // Setelah berhasil, bersihkan form
                      setState(() {
                        _controller.clearForm();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Text('SIMPAN DATA',
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