import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aturaja/data/models/registration_data_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Tambahkan GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  final Color brandRed = const Color(0xFFD40300);
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
          // Bungkus dengan Form agar validator berfungsi
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ==========================================
                // 1. AREA ILUSTRASI & JUDUL
                // ==========================================
                Image.asset(
                  'assets/images/amico.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),

                const Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),

                // ==========================================
                // 2. AREA FORM INPUT
                // ==========================================
                _buildInputField(
                  label: 'Nomor Handphone',
                  hint: 'Phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  // Terapkan formatter agar HANYA ANGKA yang bisa diketik
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Minimal 6 angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                _buildInputField(
                  label: 'Password',
                  hint: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 48),

                // ==========================================
                // 3. AREA TOMBOL DAFTAR
                // ==========================================
                SizedBox(
                  width: 140,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      // Cek apakah inputan valid sebelum diproses
                      if (_formKey.currentState!.validate()) {
                        // Instantiate RegistrationDataModel dengan phone dan password
                        final registrationModel = RegistrationDataModel(
                          phone: _phoneController.text,
                          password: _passwordController.text,
                          fullName: '', // Will be filled in DataPersonalScreen
                          email: '', // Will be filled in DataPersonalScreen
                          ktpImagePath:
                              '', // Will be filled in KtpScannerScreen
                          selfieImagePath:
                              '', // Will be filled in FaceScannerScreen
                        );

                        // Navigasi ke OTP screen dengan melempar RegistrationDataModel
                        // OTP screen akan memvalidasi OTP dan pass model forward ke DataPersonalScreen
                        Navigator.pushNamed(
                          context,
                          '/verify-otp',
                          arguments: registrationModel,
                        );

                        // Jalur cetak log untuk debugging lokal (tetap dipertahankan)
                        print("Phone: ${_phoneController.text}");
                        print("Password: ${_passwordController.text}");
                      }
                    },
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ==========================================
                // 4. AREA FOOTER (Navigasi Login)
                // ==========================================
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                      children: [
                        TextSpan(text: 'Sudah Punya Akun? '),
                        TextSpan(
                          text: 'Masuk',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET HELPER: Komponen Kolom Input Reusable
  // ==========================================
  Widget _buildInputField({
    required String label,
    required String hint,
    TextEditingController? controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    // Jadikan opsional agar kolom password tidak error
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          // Teruskan parameter inputFormatters ke dalam TextFormField
          inputFormatters: inputFormatters,
          // Teruskan parameter validator
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.black87, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: brandRed, width: 2),
            ),
            // Tambahkan desain batas saat terjadi error (validasi gagal)
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
