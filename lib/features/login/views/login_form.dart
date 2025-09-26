import 'package:flutter/material.dart';
import 'package:parkaways_ep_flutter/features/login/controllers/login_controller.dart';

class LoginForm extends StatelessWidget {
  final LoginController controller;
  final bool isPasswordObscured;
  final String? selectedShift;
  final VoidCallback onTogglePasswordVisibility;
  final ValueChanged<String?> onShiftChanged;

  const LoginForm({
    super.key,
    required this.controller,
    required this.isPasswordObscured,
    required this.selectedShift,
    required this.onTogglePasswordVisibility,
    required this.onShiftChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Parkways Express Payment",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            "Masuk Akun",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Username
        TextField(
          controller: controller.usernameController,
          keyboardType: TextInputType.text, // Keyboard standar
          cursorColor: Colors.orange,
          decoration: InputDecoration(
            labelText: "Masukkan username",
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.grey[200],
            border: const UnderlineInputBorder(),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Password
        TextField(
          controller: controller.passwordController,
          keyboardType: TextInputType.text, // <-- Diubah menjadi .text
          cursorColor: Colors.orange,
          obscureText: isPasswordObscured,
          decoration: InputDecoration(
            labelText: "Masukkan password",
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.grey[200],
            border: const UnderlineInputBorder(),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(isPasswordObscured ? Icons.visibility : Icons.visibility_off),
              onPressed: onTogglePasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        const Text(
          "Pilih Shift",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        // Ganti Row "Pilih Shift" Anda dengan kode ini
        Row(
          children: [
            // Shift 1
            Expanded(
              child: InkWell(
                onTap: () => onShiftChanged("shift1"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: "shift1",
                      groupValue: selectedShift,
                      onChanged: (value) => onShiftChanged(value),
                      activeColor: Colors.orange,
                      visualDensity:
                          VisualDensity.compact, // Membuat tombol lebih ringkas
                    ),
                    const SizedBox(
                      width: 4,
                    ), // <-- UBAH ANGKA INI UNTUK MENGATUR JARAK
                    const Text("Shift 1", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),

            // Shift 2
            Expanded(
              child: InkWell(
                onTap: () => onShiftChanged("shift2"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: "shift2",
                      groupValue: selectedShift,
                      onChanged: (value) => onShiftChanged(value),
                      activeColor: Colors.orange,
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(
                      width: 4,
                    ), // <-- UBAH ANGKA INI UNTUK MENGATUR JARAK
                    const Text("Shift 2", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),

            // Shift 3
            Expanded(
              child: InkWell(
                onTap: () => onShiftChanged("shift3"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: "shift3",
                      groupValue: selectedShift,
                      onChanged: (value) => onShiftChanged(value),
                      activeColor: Colors.orange,
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(
                      width: 4,
                    ), // <-- UBAH ANGKA INI UNTUK MENGATUR JARAK
                    const Text("Shift 3", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // IP Server
        TextField(
          controller: controller.ipServerController,
          keyboardType: TextInputType.text, // <-- Diubah menjadi .text
          cursorColor: Colors.orange,
          decoration: InputDecoration(
            labelText: "Masukkan ip server",
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.grey[200],
            border: const UnderlineInputBorder(),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Tombol Login
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                () => controller.login(context: context, shift: selectedShift),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            child: const Text(
              "MASUK AKUN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
