import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/colors.dart';

// Import HomeScreen
import '../home/home_screen.dart' as home;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _phoneError;
  String? _passwordError;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 10, end: -10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Validation (Logika 6 Angka Dimasukkan Kembali!) ───────────────────────

  bool _validate() {
    String? phoneErr;
    String? passErr;

    final phone    = _phoneController.text.trim();
    final password = _passwordController.text;

    if (phone.isEmpty) {
      phoneErr = 'Nomor telepon tidak boleh kosong';
    } else if (phone.length < 6) {
      phoneErr = 'Nomor telepon minimal 6 angka';
    } else if (!RegExp(r'^\d+$').hasMatch(phone)) {
      phoneErr = 'Nomor telepon harus berupa angka';
    }

    if (password.isEmpty) {
      passErr = 'Password tidak boleh kosong';
    } else {
      final hasUpper  = password.contains(RegExp(r'[A-Z]'));
      final hasLower  = password.contains(RegExp(r'[a-z]'));
      final hasNumber = password.contains(RegExp(r'[0-9]'));
      if (!hasUpper || !hasLower || !hasNumber) {
        passErr = 'Password harus mengandung huruf besar, kecil, dan angka';
      }
    }

    setState(() {
      _phoneError    = phoneErr;
      _passwordError = passErr;
    });

    return phoneErr == null && passErr == null;
  }

  void _handleLogin() {
    if (_validate()) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            children: [
              // Floating illustration (Diganti Icon sementara karena file temenmu nggak ada)
              SizedBox(
                height: 220,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    ),
                    child: const Icon(Icons.phone_android_rounded, size: 100, color: AppColors.brandRed),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 32),

              // Phone number (Menggunakan Helper Widget buatan sendiri)
              _buildLabeledField(
                label: 'PHONE NUMBER',
                error: _phoneError,
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDecoration(
                    hint: 'Masukkan minimal 6 angka',
                    hasError: _phoneError != null,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password
              _buildLabeledField(
                label: 'PASSWORD',
                error: _passwordError,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(
                    hint: 'Huruf besar, kecil & angka',
                    hasError: _passwordError != null,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Login button (Diganti GestureDetector + AnimatedContainer biar nggak error)
              GestureDetector(
                onTap: _handleLogin,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.brandRed,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.shade100,
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not Registered yet? ',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.brandRed,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers (Penyelamat Error) ────────────────────────────────────────────

  // Fungsi pengganti LabeledField punya temenmu yang hilang
  Widget _buildLabeledField({required String label, String? error, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        child,
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required bool hasError,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      filled: true,
      fillColor: hasError ? AppColors.errorFill : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: hasError ? Colors.red : Colors.grey.shade200,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.brandRed, width: 1.5),
      ),
    );
  }
}