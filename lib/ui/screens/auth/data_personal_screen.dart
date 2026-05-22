import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataPersonalScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const DataPersonalScreen({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<DataPersonalScreen> createState() => _DataPersonalScreenState();
}

class _DataPersonalScreenState extends State<DataPersonalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();

  // Variabel penampung pesan error untuk kustomisasi UI manual
  String? _nikError;
  String? _namaError;
  String? _alamatError;

  void _handleSubmit() {
    setState(() {
      // Reset error di awal validasi
      _nikError = null;
      _namaError = null;
      _alamatError = null;
    });

    bool isValid = true;

    // 1. Validasi Aturan NIK
    String nik = _nikController.text.trim();
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

    // 3. Validasi Aturan Alamat
    if (_alamatController.text.trim().isEmpty) {
      _alamatError = 'Alamat lengkap wajib diisi';
      isValid = false;
    }

    if (!isValid) {
      setState(() {}); // Segarkan UI untuk menampilkan pesan error kustom
      return;
    }

    // Jika seluruh form lolos verifikasi, eksekusi rute sukses keluar
    widget.onComplete();
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9), // bg-[#FAF9F9]
      body: Stack(
        children: [
          // CORE VIEWPORT LAYOUT (SCROLLABLE AREA)
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                top: 64,
                left: 24,
                right: 24,
                bottom: 120, // Padding ekstra di bawah agar konten form tidak tertutup footer
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= HEADER TITLES =================
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

                    // ================= KEAMANAN TERJAMIN CARD =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F5), // bg-[#FFF5F5]
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFFFE4E6).withOpacity(0.5)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFFFF1F2),
                            child: Icon(Icons.shield_outlined, color: Color(0xFFD31111), size: 22),
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
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ================= WHITE PANEL FORM FIELDS =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFF5F5F5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.015),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          )
                        ],
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
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: _buildInputDecoration("16 Digit No. KTP"),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF262626)),
                              onChanged: (val) {
                                if (_nikError != null) setState(() => _nikError = null);
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
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF262626)),
                              onChanged: (val) {
                                if (_namaError != null) setState(() => _namaError = null);
                              },
                            ),
                          ),
                          if (_namaError != null) _buildErrorMessage(_namaError!),

                          const SizedBox(height: 20),

                          // INPUT FIELD: ALAMAT LENGKAP
                          _buildInputLabel("ALAMAT LENGKAP"),
                          const SizedBox(height: 8),
                          _buildTextFieldContainer(
                            icon: Icons.home_outlined,
                            isError: _alamatError != null,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
                            child: TextFormField(
                              controller: _alamatController,
                              maxLines: 3,
                              decoration: _buildInputDecoration("Jl. Raya, No. Rumah, RT/RW, Kelurahan/Kecamatan"),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF262626)),
                              onChanged: (val) {
                                if (_alamatError != null) setState(() => _alamatError = null);
                              },
                            ),
                          ),
                          if (_alamatError != null) _buildErrorMessage(_alamatError!),

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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 4,
                                shadowColor: const Color(0xFFD31111).withOpacity(0.2),
                              ),
                              child: const Text(
                                "Selesai",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

          // ================= FIXED BOTTOM FOOTER PANEL =================
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
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Help action tab
                    _buildFooterButton(
                      icon: Icons.help_outline_rounded,
                      label: "BANTUAN",
                      onTap: () {},
                    ),
                    
                    // Vertical divider line
                    Container(width: 1.5, height: 32, color: const Color(0xFFF5F5F5)),
                    
                    // Terms & conditions tab
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
        crossAxisAlignment: alignment == Alignment.topLeft ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: alignment == Alignment.topLeft ? const EdgeInsets.only(top: 2) : EdgeInsets.zero,
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
      counterText: "", // Menghilangkan teks counter bawaan maxLength Flutter
      hintStyle: const TextStyle(color: Color(0xFFA3A3A3), fontSize: 14, fontWeight: FontWeight.w500),
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
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
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