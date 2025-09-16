import 'package:flutter/material.dart';
import '../../controllers/tiket_hilang_controllers.dart';
import 'custom_text_field.dart';

class CustomerDataForm extends StatelessWidget {
  final LostTicketController controller;
  const CustomerDataForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Customer',
          style: TextStyle(color: Color.fromRGBO(251, 192, 45, 1), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CustomTextField(label: 'Nama Customer', controller: controller.customerNameController),
        const SizedBox(height: 16),
        CustomTextField(label: 'No. Handphone', controller: controller.phoneController),
        const SizedBox(height: 16),
        CustomTextField(label: 'No. KTP', controller: controller.idNumberController),
      ],
    );
  }
}