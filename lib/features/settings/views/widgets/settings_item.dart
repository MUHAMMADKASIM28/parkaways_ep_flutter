// lib/features/settings/views/widgets/setting_item.dart

import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final TextEditingController? textFieldController;
  final String? hintText;
  final bool isLogoutButton;

  const SettingItem(
      {super.key,
      required this.title,
      this.subtitle,
      this.buttonText,
      this.onButtonPressed,
      this.textFieldController,
      this.hintText,
      this.isLogoutButton = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                if (textFieldController == null)
                  Text(subtitle ?? '',
                      style: const TextStyle(color: Colors.grey))
                else
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      controller: textFieldController,
                      decoration: InputDecoration(
                        // Diubah: Atur properti untuk warna dan border
                        filled: true,
                        fillColor: Colors.white,
                        hintText: hintText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none, // Hapus garis pinggir
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (onButtonPressed != null && buttonText != null) ...[
            const SizedBox(width: 16),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      isLogoutButton ? Colors.red : Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(buttonText!),
              ),
            ),
          ]
        ],
      ),
    );
  }
}