// lib/services/printer_service.dart

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import '../features/dashboard/models/dashboard_models.dart';

class PrinterService {
  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;

  Future<void> printReceipt(TransactionData data, int total, String kasir) async {
    // Cek apakah printer sudah terhubung
    bool? isConnected = await _printer.isConnected;
    if (isConnected != true) {
      throw Exception('Printer tidak terhubung. Silakan atur di halaman Settings.');
    }

    // Siapkan data struk
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // Cetak header
    await _printer.printCustom("PARKWAYS EXPRESS PAYMENT", 2, 1); // Teks, Ukuran, Align
    await _printer.printCustom("BSS Office", 1, 1);
    await _printer.printNewLine();

    // Cetak detail transaksi
    await _printer.printLeftRight("Kasir", kasir, 1);
    await _printer.printLeftRight("Plat Nomor", data.plateNumber, 1);
    await _printer.printLeftRight("Jenis", data.vehicleType, 1);
    await _printer.printLeftRight("Waktu Masuk", dateFormat.format(data.entryTime), 1);
    await _printer.printLeftRight("Waktu Keluar", dateFormat.format(data.scanTime), 1);
    await _printer.printCustom("--------------------------------", 1, 1);

    // Cetak Total
    await _printer.printLeftRight("TOTAL", currencyFormat.format(total), 2);
    await _printer.printCustom("--------------------------------", 1, 1);
    await _printer.printNewLine();

    // Cetak footer
    await _printer.printCustom("Terima Kasih", 1, 1);
    await _printer.printCustom("Selamat Jalan Kembali", 1, 1);
    await _printer.paperCut(); // Potong kertas (jika didukung)
  }
}