import 'dart:io';
import 'package:flutter/material.dart';

class ConfirmSelfieScreen extends StatelessWidget {
  final String imagePath;
  final VoidCallback onConfirm;
  final VoidCallback onRetake;

  const ConfirmSelfieScreen({
    Key? key,
    required this.imagePath,
    required this.onConfirm,
    required this.onRetake,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9), // Warna netral bg-neutral-50/50
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ================= TOP HEADER SECTION =================
                        const SizedBox(height: 8),
                        const Text(
                          "Apakah Selfie Sudah Jelas?",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0A0A0A),
                            letterSpacing: -0.5,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Pastikan seluruh wajah terlihat jelas tanpa bayangan\natau penghalang untuk keamanan akun Anda.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),

                        // ================= MAIN SELFIE DISPLAY SLOT =================
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 360),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF1F2).withOpacity(0.15), // bg-rose-50/15
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: const Color(0xFFFECDD3), // border-rose-200
                                    width: 2.5,
                                    style: BorderStyle.solid, // Representasi visual dash
                                  ),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: AspectRatio(
                                  aspectRatio: 1.35,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      color: const Color(0xFFF5F5F5),
                                      child: imagePath.isNotEmpty && File(imagePath).existsSync()
                                          ? Image.file(
                                              File(imagePath),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                            )
                                          : _buildVectorFallbackMesh(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ================= VERIFICATION PROMPT CARD BAR =================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFF5F5F5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Color(0xFFFFF1F2), // bg-rose-50
                                child: Icon(Icons.visibility_outlined, color: Color(0xFFD31111), size: 20),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Apakah foto sudah jelas?",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF171717),
                                      ),
                                    ),
                                    SizedBox(height: 2),
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
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ================= CUSTOM MATCHING TIPS SECTION =================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0xFFE5E5E5).withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lightbulb_outline, color: Colors.grey, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    "TIPS KUALITAS FOTO",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTipRow("Pencahayaan cukup dan merata"),
                              const SizedBox(height: 12),
                              _buildTipRow("Wajah tidak terpotong (masuk dalam frame)"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ================= DOUBLE INTERACTIVE ACTIONS FOOTER =================
// ================= DOUBLE INTERACTIVE ACTIONS FOOTER =================
                        Row(
                          children: [
                            // Button Retake (Foto Ulang)
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: OutlinedButton(
                                  onPressed: onRetake,
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Color(0xFFE5E5E5)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: const EdgeInsets.symmetric(horizontal: 4), // Mencegah padding dalam terlalu ketat
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min, // Mengunci ukuran seminimal mungkin
                                    children: [
                                      Icon(Icons.refresh_rounded, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      const Flexible(
                                        child: Text(
                                          "Foto Ulang",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis, // Jika mentok, otomatis jadi "Foto..."
                                          style: TextStyle(
                                            fontSize: 13, // Diturunkan sedikit dari 14 agar lebih aman di layar kecil
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF424242),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12), // Dipersempit sedikit dari 16 agar ruang tombol lebih luas
                            
                            // Button Confirm (Gunakan Foto) - SOLUSI UTAMA OVERFLOW
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: onConfirm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD31111),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: const EdgeInsets.symmetric(horizontal: 4), // Longgarkan area dalam tombol
                                    elevation: 3,
                                    shadowColor: const Color(0xFFD31111).withOpacity(0.2),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_rounded, size: 16, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Flexible( // Ditambahkan agar teks mengalah mengikuti batas sisa ruang tombol
                                        child: Text(
                                          "Gunakan Foto",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis, // Potong teks dengan titik tiga jika benar-benar tidak muat
                                          style: TextStyle(
                                            fontSize: 13, // Dioptimalkan menjadi 13 agar pas berdampingan dengan ikon
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTipRow(String tipText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFF1F2).withOpacity(0.2),
            border: Border.all(color: const Color(0xFFFECDD3)),
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
              color: Color(0xFF404040),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVectorFallbackMesh() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFAF4F0), Color(0xFFE2D4C9), Color(0xFF8C7A6B)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.account_box_rounded,
          size: 80,
          color: const Color(0xFF1A1A1A).withOpacity(0.6),
        ),
      ),
    );
  }
}