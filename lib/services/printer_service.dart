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

    // --- PERUBAHAN FORMAT DAN PERATAAN DI SINI ---

    // Siapkan data struk sesuai format baru
    final firstLine = "BSS Office";
    // Gunakan kode tiket dari objek 'data'
    final secondLine = "${data.transactionCode} * ${DateFormat('yyyy-MM-dd HH:mm:ss').format(data.scanTime)}";
    final thirdLine = "${data.vehicleType} * ${total.toString()} * ${kasir}";
    final fourthLine = "Struk ini merupakan bukti";
    final fifthLine = "pembayaran yang sah.";
    final sixthLine = "------- www.parkways.id -------";

    // Mengatur perataan dan ukuran font
    // Ukuran: 0 (kecil), 1 (sedang), 2 (besar)
    // Perataan: 0 (kiri), 1 (tengah), 2 (kanan)
    const int size = 1;     // Ukuran font sedang
    const int align = 1;    // Perataan tengah

    // Cetak setiap baris
    await _printer.printCustom(firstLine, size, align);
    await _printer.printNewLine(); // Beri spasi satu baris
    await _printer.printCustom(secondLine, size, align);
    await _printer.printCustom(thirdLine, size, align);
    await _printer.printNewLine(); // Beri spasi satu baris
    await _printer.printCustom(fourthLine, size, align);
    await _printer.printCustom(fifthLine, size, align);
    await _printer.printNewLine(); // Beri spasi satu baris
    await _printer.printCustom(sixthLine, size, align);

    // Beri beberapa baris kosong di akhir untuk memudahkan penyobekan
    await _printer.printNewLine();

    // Potong kertas (jika printer mendukung)
    await _printer.paperCut();
    // --- AKHIR PERUBAHAN ---
  }
}