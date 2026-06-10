import 'dart:io';
import 'package:flutter/material.dart';
// TODO: Pastikan path import ini sesuai dengan struktur folder Anda
import 'package:aturaja/data/models/registration_data_model.dart';

class ConfirmKtpScreen extends StatefulWidget {
  // BERSIH: Tidak ada parameter yang diminta dari luar!
  const ConfirmKtpScreen({super.key});

  @override
  State<ConfirmKtpScreen> createState() => _ConfirmKtpScreenState();
}

class _ConfirmKtpScreenState extends State<ConfirmKtpScreen> {
  late RegistrationDataModel _registrationModel;
  bool _modelLoaded = false;
  String _imagePath = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Menangkap "Koper Data" dari layar sebelumnya
    if (!_modelLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RegistrationDataModel) {
        _registrationModel = args;
        _imagePath = _registrationModel
            .ktpImagePath; // Ambil path foto KTP dari dalam model
        _modelLoaded = true;
      }
    }
  }

  // Aksi jika tombol "Gunakan Foto" ditekan
  void _handleConfirm() {
    // Lanjut ke Face Scanner dengan membawa koper data yang sama
    Navigator.pushNamed(context, '/scan-face', arguments: _registrationModel);
  }

  // Aksi jika tombol "Foto Ulang" ditekan
  void _handleRetake() {
    // Kembali ke halaman KTP Scanner (menghapus halaman konfirmasi ini dari stack)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Error handling jika halaman dibuka tanpa membawa data
    if (!_modelLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Data registrasi tidak ditemukan. Gagal memuat foto."),
        ),
      );
    }

    // Memeriksa keberadaan file foto hasil tangkapan kamera dari model
    final bool hasValidImage =
        _imagePath.isNotEmpty && File(_imagePath).existsSync();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP HEADER SECTION
              const SizedBox(height: 8),
              const Text(
                "Konfirmasi Foto",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A0A0A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Pastikan seluruh bagian KTP berada di dalam kotak,\ndata terbaca jelas, dan tidak ada pantulan cahaya.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // 2. MAIN KTP FRAME SLOT
              Center(
                child: AspectRatio(
                  aspectRatio: 1.58,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFFECDD3),
                        width: 2.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Colors.grey,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (hasValidImage)
                              Image.file(File(_imagePath), fit: BoxFit.cover)
                            else
                              const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo_camera_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Memuat gambar...",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
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
                ),
              ),

              const SizedBox(height: 28),

              // 3. VISUAL QUESTION BANNER
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1F2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.visibility,
                        color: Color(0xFFD31111),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Apakah foto sudah jelas?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Data harus terbaca tanpa buram atau silau.",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. TIPS BLOCK SECTION
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB).withOpacity(0.5),
                  ),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.grey,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "TIPS KUALITAS FOTO",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B7280),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTipRow("Pencahayaan cukup dan merata"),
                    const SizedBox(height: 12),
                    _buildTipRow("KTP tidak terpotong (masuk dalam frame)"),
                    const SizedBox(height: 12),
                    _buildTipRow("Teks dan angka terbaca dengan tajam"),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 5. FOOTER BUTTON ACTION ROW
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _handleRetake, // Memanggil fungsi Retake
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, size: 14, color: Colors.grey),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                "Foto Ulang",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleConfirm, // Memanggil fungsi Confirm
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD31111),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 14),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                "Gunakan Foto",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipRow(String tipText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            border: Border.all(color: const Color(0xFFFEE2E2)),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.check, size: 10, color: Color(0xFFD31111)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            tipText,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }
}
