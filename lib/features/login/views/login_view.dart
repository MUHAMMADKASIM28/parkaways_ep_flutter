import 'package:flutter/material.dart';
import 'package:parkaways_ep_flutter/features/login/controllers/login_controller.dart';
import 'package:parkaways_ep_flutter/features/login/views/branding_section.dart'; // Panggil file branding
import 'package:parkaways_ep_flutter/features/login/views/login_form.dart'; // Panggil file form

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: LoginView()),
  );
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  bool _isPasswordObscured = true;
  String? _selectedShift;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  void _onShiftChanged(String? value) {
    setState(() {
      _selectedShift = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF0056D2), // Latar belakang
        width: double.infinity,
        height: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 600;

            if (isWideScreen) {
              // Tampilan Lebar: Atur widget BrandingSection dan LoginForm berdampingan
              return Row(
                children: [
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 350,
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: SingleChildScrollView(
                              child: LoginForm(
                                controller: _controller,
                                isPasswordObscured: _isPasswordObscured,
                                selectedShift: _selectedShift,
                                onTogglePasswordVisibility: _togglePasswordVisibility,
                                onShiftChanged: _onShiftChanged,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: BrandingSection(),
                  ),
                ],
              );
            } else {
              // Tampilan Sempit: Atur widget BrandingSection dan LoginForm bertumpuk
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const BrandingSection(isNarrow: true),
                        const SizedBox(height: 40),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: LoginForm(
                              controller: _controller,
                              isPasswordObscured: _isPasswordObscured,
                              selectedShift: _selectedShift,
                              onTogglePasswordVisibility: _togglePasswordVisibility,
                              onShiftChanged: _onShiftChanged,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}