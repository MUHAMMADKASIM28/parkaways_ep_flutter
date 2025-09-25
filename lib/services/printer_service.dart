// lib/services/printer_service.dart

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import '../features/dashboard/models/dashboard_models.dart';
import '../features/tiket_hilang/models/tiket_hilang_models.dart'; // Impor model tiket hilang

class PrinterService {
  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;

  Future<void> printReceipt(TransactionData data, int total, String kasir) async {
    bool? isConnected = await _printer.isConnected;
    if (isConnected != true) {
      throw Exception('Printer tidak terhubung. Silakan atur di halaman Settings.');
    }

    final firstLine = "BSS Office";
    final secondLine = "${data.transactionCode} * ${DateFormat('yyyy-MM-dd HH:mm:ss').format(data.scanTime)}";
    final thirdLine = "${data.vehicleType} * ${total.toString()} * ${kasir}";
    final fourthLine = "Struk ini merupakan bukti";
    final fifthLine = "pembayaran yang sah.";
    final sixthLine = "------- www.parkways.id -------";

    const int size = 1;
    const int align = 1;

    await _printer.printCustom(firstLine, size, align);
    await _printer.printNewLine();
    await _printer.printCustom(secondLine, size, align);
    await _printer.printCustom(thirdLine, size, align);
    await _printer.printNewLine();
    await _printer.printCustom(fourthLine, size, align);
    await _printer.printCustom(fifthLine, size, align);
    await _printer.printNewLine();
    await _printer.printCustom(sixthLine, size, align);
    await _printer.printNewLine();
    await _printer.paperCut();
  }

  // --- FUNGSI TIKET HILANG TELAH DIMODIFIKASI ---
  Future<void> printLostTicketReceipt(LostTicketModel data, String kasir) async {
    bool? isConnected = await _printer.isConnected;
    if (isConnected != true) {
      throw Exception('Printer tidak terhubung. Silakan atur di halaman Settings.');
    }

    const int size = 1; // Ukuran font minimalis yang sama rata
    const int align = 1; // Perataan tengah

    // 1. Tambahkan "BSS Office" di paling atas
    await _printer.printCustom("BSS Office", size, align);
    await _printer.printNewLine();
    await _printer.printCustom("Struk Denda Tiket Hilang", size, align);
    await _printer.printNewLine();
    await _printer.printCustom("${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}", size, align);
    await _printer.printCustom("$kasir", size, align);
    await _printer.printNewLine();
    await _printer.printCustom("Nama: ${data.customerName}", size, align);
    await _printer.printCustom("No.Plat: ${data.platCode} ${data.licensePlate}", size, align);
    await _printer.printCustom("Jenis: ${data.vehicleType}", size, align);
    await _printer.printNewLine();
    // 2. Ubah ukuran font total denda menjadi sama dengan yang lain
    await _printer.printCustom("Total Denda: Rp. ${data.totalFee}", size, align);
    await _printer.printNewLine();
    await _printer.printCustom("Struk ini merupakan bukti", size, align);
    await _printer.printCustom("pembayaran denda yang sah.", size, align);
    await _printer.printNewLine();
    await _printer.printCustom("------- www.parkways.id -------", size, align);
    await _printer.paperCut();
  }
  // --- AKHIR FUNGSI ---
}