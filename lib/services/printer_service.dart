// lib/services/printer_service.dart

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import '../features/dashboard/models/dashboard_models.dart';
import '../features/tiket_hilang/models/tiket_hilang_models.dart'; // Impor model tiket hilang

class PrinterService {
  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;

  // --- FUNGSI DIUBAH DI SINI ---
  Future<void> printReceipt(
      {required TransactionData data,
      required int total,
      required String kasir,
      required String locationName}) async {
    // --- AKHIR PERUBAHAN ---
    bool? isConnected = await _printer.isConnected;
    if (isConnected != true) {
      throw Exception('Printer tidak terhubung. Silakan atur di halaman Settings.');
    }

    // --- DIUBAH: Gunakan variabel locationName ---
    final firstLine = locationName;
    // --- AKHIR PERUBAHAN ---
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

  // --- FUNGSI DIUBAH DI SINI ---
  Future<void> printLostTicketReceipt(
      {required LostTicketModel data,
      required String kasir,
      required String locationName}) async {
    // --- AKHIR PERUBAHAN ---
    bool? isConnected = await _printer.isConnected;
    if (isConnected != true) {
      throw Exception('Printer tidak terhubung. Silakan atur di halaman Settings.');
    }

    const int size = 1; // Ukuran font minimalis yang sama rata
    const int align = 1; // Perataan tengah

    // --- DIUBAH: Gunakan variabel locationName ---
    await _printer.printCustom(locationName, size, align);
    // --- AKHIR PERUBAHAN ---
    await _printer.printNewLine();
    await _printer.printCustom("Struk Denda Tiket Hilang", size, align);
    await _printer.printCustom("${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())} * $kasir", size, align);
    await _printer.printNewLine();
    await _printer.printCustom("${data.customerName} * ${data.platCode} ${data.licensePlate} * ${data.vehicleType}", size, align);
    await _printer.printCustom("Total Denda: Rp. ${data.totalFee}", size, align);
    await _printer.printNewLine();
    await _printer.printCustom("Struk ini merupakan bukti", size, align);
    await _printer.printCustom("pembayaran denda yang sah.", size, align);
    await _printer.printNewLine();
    await _printer.printCustom("------- www.parkways.id -------", size, align);
    await _printer.paperCut();
  }
}