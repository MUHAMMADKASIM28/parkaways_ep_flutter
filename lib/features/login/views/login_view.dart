import 'package:flutter/material.dart';
import 'package:parkaways_ep_flutter/features/login/controllers/login_controller.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: LoginView()),
  );
}

// 1. Diubah menjadi StatefulWidget agar bisa menyimpan state
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  // 2. Variabel untuk melacak status password (tersembunyi/tidak)
  bool _isPasswordObscured = true;

  String? _selectedShift; // Untuk menyimpan shift yg dipilih, misal: "shift1"

  // 3. Fungsi untuk mengubah status visibilitas password
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF0056D2), // biru full background
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            // Bagian kiri (Form Login)
            Expanded(
              flex: 1,
              child: Center(
                child: SizedBox(
                  width: 350,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Parkways Express Payment",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Center(
                            child: Text(
                              "Masuk Akun",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey, // lebih terang
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Username
                          TextField(
                            controller: _controller.usernameController,
                            cursorColor: Colors.orange,
                            decoration: InputDecoration(
                              labelText: "Masukkan username",
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ), // warna awal
                              floatingLabelStyle: const TextStyle(
                                color: Colors.black,
                              ), // tetap hitam meski naik
                              filled: true, // aktifkan background
                              fillColor: Colors.grey[200], // warna abu-abu
                              border: const UnderlineInputBorder(),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password
                          // 4. TextField Password dimodifikasi di sini
                          TextField(
                            controller: _controller.passwordController,
                            cursorColor: Colors.orange,
                            obscureText:
                                _isPasswordObscured, // Terhubung ke state
                            decoration: InputDecoration(
                              labelText: "Masukkan password",
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ), // warna awal
                              floatingLabelStyle: const TextStyle(
                                color: Colors.black,
                              ), // tetap hitam meski naik
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: const UnderlineInputBorder(),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordObscured
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Pilih Shift
                          const Text(
                            "Pilih Shift",
                            style: TextStyle(
                              color: Colors.grey, // lebih terang
                              fontSize: 16,
                            ),
                          ),
                          // Ganti Row "Pilih Shift" Anda dengan ini
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Shift 1"),
                                  value: "shift1",
                                  // Hubungkan ke variabel state
                                  groupValue: _selectedShift,
                                  activeColor:
                                      Colors.orange, // <-- Tambahkan baris ini
                                  // Update state saat item ini dipilih
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedShift = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Shift 2"),
                                  value: "shift2",
                                  // Hubungkan ke variabel state yang sama
                                  groupValue: _selectedShift,
                                  activeColor:
                                      Colors.orange, // <-- Tambahkan baris ini
                                  // Update state saat item ini dipilih
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedShift = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Shift 3"),
                                  value: "shift3",
                                  // Hubungkan ke variabel state yang sama
                                  groupValue: _selectedShift,
                                  activeColor:
                                      Colors.orange, // <-- Tambahkan baris ini
                                  // Update state saat item ini dipilih
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedShift = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // IP Server
                          TextField(
                            controller: _controller.ipServerController,
                            cursorColor: Colors.orange,
                            decoration: InputDecoration(
                              labelText: "Masukkan ip server",
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ), // warna awal
                              floatingLabelStyle: const TextStyle(
                                color: Colors.black,
                              ), // tetap hitam meski naik
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: const UnderlineInputBorder(),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Tombol Login
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              // 3. Panggil fungsi login dari controller saat ditekan
                              onPressed: () {
                                _controller.login(
                                  context: context,
                                  shift: _selectedShift,
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange, // Warna tombol
                                foregroundColor:
                                    Colors.black, // Warna teks & ikon
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                elevation: 0, // flat style
                              ),
                              child: const Text(
                                "MASUK AKUN",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black, // teks tetap hitam
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bagian kanan (Logo + Tagline)
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // sejajarkan secara vertikal
                  children: [
                    // 🔹 Logo
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: Image.asset("assets/icons/logo-parkways.png"),
                    ),
                    const SizedBox(width: 12), // jarak antara logo dan teks
                    // 🔹 Kolom teks
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        // Parkways
                        Text(
                          "Parkways",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),

                        // Digital Parking Transformation
                        Text(
                          "Digital Parking Transformation",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
