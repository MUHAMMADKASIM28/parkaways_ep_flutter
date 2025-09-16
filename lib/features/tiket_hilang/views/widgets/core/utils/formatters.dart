import 'package:intl/intl.dart';

class AppFormatters {
  static final currency = NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 2,
  );
}