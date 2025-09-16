import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class CustomerDataForm extends StatelessWidget {
  const CustomerDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Customer',
          style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        CustomTextField(label: 'Masukkan Nama Customer'),
        SizedBox(height: 16),
        CustomTextField(label: 'No. Handphone'),
        SizedBox(height: 16),
        CustomTextField(label: 'No. KTP'),
      ],
    );
  }
}