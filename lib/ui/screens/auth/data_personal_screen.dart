import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aturaja/data/models/registration_data_model.dart'; // Sesuaikan path
import 'package:aturaja/data/repositories/auth_repository.dart'; // Pastikan file AuthRepository Fase 1 sudah ada

class DataPersonalScreen extends StatefulWidget {
  const DataPersonalScreen({Key? key}) : super(key: key);

  @override
  State<DataPersonalScreen> createState() => _DataPersonalScreenState();
}

class _DataPersonalScreenState extends State<DataPersonalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _emailController =
      TextEditingController(); // <--- TAMBAHAN CONTROLLER EMAIL
  final _alamatController = TextEditingController();

  String? _nikError;
  String? _namaError;
  String? _emailError; // <--- TAMBAHAN VARIABLE ERROR EMAIL
  String? _alamatError;

  late RegistrationDataModel _registrationModel;
  bool _modelLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_modelLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RegistrationDataModel) {
        _registrationModel = args;
        _modelLoaded = true;
      }
    }
  }

  // EKSEKUSI PENDAFTARAN MASAL KE FIREBASE CLOUD
  Future<void> _handleSubmit() async {
    setState(() {
      _nikError = null;
      _namaError = null;
      _emailError = null; // <--- RESET ERROR EMAIL
      _alamatError = null;
    });

    bool isValid = true;
    String nik = _nikController.text.trim();
    String email = _emailController.text.trim();

    // 1. Validasi Aturan NIK
    if (nik.isEmpty) {
      _nikError = 'NIK wajib diisi';
      isValid = false;
    } else if (nik.length != 16) {
      _nikError = 'NIK harus terdiri dari 16 digit';
      isValid = false;
    }

    // 2. Validasi Aturan Nama
    if (_namaController.text.trim().isEmpty) {
      _namaError = 'Nama lengkap wajib diisi';
      isValid = false;
    }

    // 3. Validasi Aturan Email (Tambahan)
    if (email.isEmpty) {
      _emailError = 'Email wajib diisi';
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = 'Format email tidak valid (contoh: user@gmail.com)';
      isValid = false;
    }

    // 4. Validasi Aturan Alamat
    if (_alamatController.text.trim().isEmpty) {
      _alamatError = 'Alamat lengkap wajib diisi';
      isValid = false;
    }

    if (!isValid || !_modelLoaded) {
      setState(() {});
      return;
    }

    // Munculkan Dialog Loading Kunci Layar
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD31111)),
        ),
      ),
    );

    // Kemas seluruh data personal ke dalam Koper Data
    final completeModel = _registrationModel.copyWith(
      nik: _nikController.text.trim(),
      fullName: _namaController.text.trim(),
      email: email, // <--- EMAIL SEKARANG BERHASIL DIKEMAS DENGAN VALID
      alamat: _alamatController.text.trim(),
    );

    try {
      final AuthRepository authRepo = AuthRepository();
      await authRepo.registerCompleteUser(completeModel);

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi Akun KYC Sukses Berhasil!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pendaftaran gagal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _emailController.dispose(); // <--- DISPOSE CONTROLLER EMAIL
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_modelLoaded) {
      return const Scaffold(
        body: Center(child: Text("Sesi data pendaftaran kedaluwarsa.")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                top: 64,
                left: 24,
                right: 24,
                bottom: 120,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "REGISTRASI PROFIL",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD31111),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Data Personal",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0A0A0A),
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Lengkapi informasi di bawah ini dan verifikasi identitas Anda pada sistem AturAja.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F5),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFFFE4E6).withOpacity(0.5),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFFFF1F2),
                            child: Icon(
                              Icons.shield_outlined,
                              color: Color(0xFFD31111),
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Keamanan Terjamin",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFD31111),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Seluruh data NIK dan informasi pribadi Anda dienkripsi menggunakan standar keamanan finansial terkini.",
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF525252),
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFF5F5F5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // INPUT FIELD: NIK
                          _buildInputLabel("NIK (NOMOR INDUK KEPENDUDUKAN)"),
                          const SizedBox(height: 8),
                          _buildTextFieldContainer(
                            icon: Icons.credit_card_outlined,
                            isError: _nikError != null,
                            child: TextFormField(
                              controller: _nikController,
                              keyboardType: TextInputType.number,
                              maxLength: 16,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: _buildInputDecoration(
                                "16 Digit No. KTP",
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF262626),
                              ),
                              onChanged: (val) {
                                if (_nikError != null)
                                  setState(() => _nikError = null);
                              },
                            ),
                          ),
                          if (_nikError != null) _buildErrorMessage(_nikError!),

                          const SizedBox(height: 20),

                          // INPUT FIELD: NAMA LENGKAP
                          _buildInputLabel("NAMA LENGKAP"),
                          const SizedBox(height: 8),
                          _buildTextFieldContainer(
                            icon: Icons.person_outline_rounded,
                            isError: _namaError != null,
                            child: TextFormField(
                              controller: _namaController,
                              keyboardType: TextInputType.name,
                              decoration: _buildInputDecoration("Nama Lengkap"),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF262626),
                              ),
                              onChanged: (val) {
                                if (_namaError != null)
                                  setState(() => _namaError = null);
                              },
                            ),
                          ),
                          if (_namaError != null)
                            _buildErrorMessage(_namaError!),

                          const SizedBox(height: 20),

                          // ==========================================
                          // NEW INPUT FIELD: EMAIL (TAMBAHAN SINKRONISASI)
                          // ==========================================
                          _buildInputLabel("ALAMAT EMAIL"),
                          const SizedBox(height: 8),
                          _buildTextFieldContainer(
                            icon: Icons.email_outlined,
                            isError: _emailError != null,
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _buildInputDecoration(
                                "contoh: user@gmail.com",
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF262626),
                              ),
                              onChanged: (val) {
                                if (_emailError != null)
                                  setState(() => _emailError = null);
                              },
                            ),
                          ),
                          if (_emailError != null)
                            _buildErrorMessage(_emailError!),

                          const SizedBox(height: 20),

                          // INPUT FIELD: ALAMAT LENGKAP
                          _buildInputLabel("ALAMAT LENGKAP"),
                          const SizedBox(height: 8),
                          _buildTextFieldContainer(
                            icon: Icons.home_outlined,
                            isError: _alamatError != null,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 12,
                              bottom: 4,
                            ),
                            child: TextFormField(
                              controller: _alamatController,
                              maxLines: 3,
                              decoration: _buildInputDecoration(
                                "Jl. Raya, No. Rumah, RT/RW, Kelurahan/Kecamatan",
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF262626),
                              ),
                              onChanged: (val) {
                                if (_alamatError != null)
                                  setState(() => _alamatError = null);
                              },
                            ),
                          ),
                          if (_alamatError != null)
                            _buildErrorMessage(_alamatError!),

                          const SizedBox(height: 28),

                          // BUTTON SUBMIT (SELESAI)
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD31111),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                shadowColor: const Color(
                                  0xFFD31111,
                                ).withOpacity(0.2),
                              ),
                              child: const Text(
                                "Selesai",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                border: const Border(top: BorderSide(color: Color(0xFFF5F5F5))),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFooterButton(
                      icon: Icons.help_outline_rounded,
                      label: "BANTUAN",
                      onTap: () {},
                    ),
                    Container(
                      width: 1.5,
                      height: 32,
                      color: const Color(0xFFF5F5F5),
                    ),
                    _buildFooterButton(
                      icon: Icons.description_outlined,
                      label: "SYARAT & KETENTUAN",
                      onTap: () {},
                      textColor: const Color(0xFFB3ADAD),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPER UI REUSABLE BUILDERS =================

  Widget _buildInputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Color(0xFFA3A3A3),
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildTextFieldContainer({
    required IconData icon,
    required Widget child,
    required bool isError,
    Alignment alignment = Alignment.center,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      alignment: alignment,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError ? Colors.red.shade400 : const Color(0xFFF5F5F5),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: alignment == Alignment.topLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: alignment == Alignment.topLeft
                ? const EdgeInsets.only(top: 2)
                : EdgeInsets.zero,
            child: Icon(icon, color: const Color(0xFFA3A3A3), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      counterText: "",
      hintStyle: const TextStyle(
        color: Color(0xFFA3A3A3),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildFooterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color textColor = const Color(0xFF9E9E9E),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFA3A3A3), size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
