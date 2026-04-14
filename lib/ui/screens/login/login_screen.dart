import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/colors.dart';
import '../home/home_screen.dart' as home;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // 1. TAMBAHKAN GLOBAL KEY (Wajib kriteria ETS)
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  // 2. LOGIKA LOGIN DENGAN VALIDASI FORM & SNACKBAR
  void _handleLogin() {
    // Mengecek apakah form valid menggunakan GlobalKey
    if (_formKey.currentState!.validate()) {
      // Menampilkan SnackBar (Wajib kriteria ETS)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Berhasil! Selamat Datang.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Delay sebentar biar SnackBar kelihatan, lalu pindah halaman
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),

          // 3. BUNGKUS DENGAN WIDGET FORM
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeaderAnimation(),
                const SizedBox(height: 32),
                Text(
                  'Login',
                  style:
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ) ??
                      const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 32),

                // 4. GANTI MENJADI TEXTFORMFIELD + VALIDATOR
                _buildFieldLabel('PHONE NUMBER', context),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDecoration(
                    hint: 'Masukkan minimal 6 angka',
                  ),
                  // ATURAN VALIDASI 1
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Nomor telepon minimal 6 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                _buildFieldLabel('PASSWORD', context),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(
                    hint: 'Huruf besar, kecil & angka',
                  ),
                  // ATURAN VALIDASI 2
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    // Validasi regex huruf besar, kecil, angka
                    if (!RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                    ).hasMatch(value)) {
                      return 'Harus mengandung huruf besar, kecil, dan angka';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                _buildLoginButton(context),
                const SizedBox(height: 32),
                _buildSignUpText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI HELPER WIDGETS ---

  Widget _buildHeaderAnimation() {
    return SizedBox(
      height: 220,
      child: Center(
        child: AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: child,
          ),
          child: const Icon(
            Icons.phone_android_rounded,
            size: 100,
            color: AppColors.brandRed,
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: _handleLogin,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
    );
  }

  Widget _buildSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Not Registered yet? ',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        Text(
          'Sign Up',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    final theme = Theme.of(context);
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: theme.colorScheme.onSurface.withOpacity(0.4),
        fontSize: 14,
      ),
      filled: true,
      fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color:
              theme.inputDecorationTheme.focusedBorder?.borderSide.color ??
              Colors.transparent,
          width: 1.5,
        ),
      ),
    );
  }
}
