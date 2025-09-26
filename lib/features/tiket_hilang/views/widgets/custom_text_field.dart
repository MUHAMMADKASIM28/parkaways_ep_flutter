import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromRGBO(251, 192, 45, 1)),
        alignLabelWithHint: true,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        filled: true,
        // DIUBAH: Ganti warna background textfield di baris ini
        fillColor: const Color(0xFF1E1E3F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}