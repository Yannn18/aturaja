import 'dart:io';
import 'package:flutter/material.dart';

class ConfirmKtpScreen extends StatelessWidget {
  final String imagePath;
  final VoidCallback onConfirm;
  final VoidCallback onRetake;

  const ConfirmKtpScreen({
    Key? key,
    required this.imagePath,
    required this.onConfirm,
    required this.onRetake,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Memeriksa keberadaan file foto hasil tangkapan kamera
    final bool hasValidImage = imagePath.isNotEmpty && File(imagePath).existsSync();

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
              Text(
                "Pastikan seluruh bagian KTP berada di dalam kotak,\ndata terbaca jelas, dan tidak ada pantulan cahaya.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // 2. MAIN KTP FRAME SLOT (MURNI MENAMPILKAN HASIL JEP RETAN KAMERA)
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
                        color: Colors.grey, // Background putih netral samar jika foto belum termuat
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // LANGSUNG TAMPILKAN FOTO HASIL TANGKAPAN KAMERA
                            if (hasValidImage)
                              Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                              )
                            else
                              // Jika gambar belum lolos, tampilkan placeholder minimalis berwarna netral (bukan biru)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.photo_camera_outlined, size: 40, color: Colors.grey),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Memuat gambar...",
                                      style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
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
                      child: const Icon(Icons.visibility, color: Color(0xFFD31111), size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Apakah foto sudah jelas?",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Data harus terbaca tanpa buram atau silau.",
                            style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
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
                  border: Border.all(color: const Color(0xFFE5E7EB).withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.grey, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          "TIPS KUALITAS FOTO",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6B7280), letterSpacing: 1),
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

              // 5. FOOTER BUTTON ACTION ROW (SUDAH FIX ANTI OVERFLOW KANAN)
              Row(
                children: [
                  // BUTTON LEFT: RETAKE FOTO
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: onRetake,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            const Flexible(
                              child: Text(
                                "Foto Ulang",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // BUTTON RIGHT: CONFIRM FOTO (DIAMANKAN DENGAN FLEXIBLE AGAR TIDAK MELEBAR)
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD31111),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
          child: const Center(child: Icon(Icons.check, size: 10, color: Color(0xFFD31111))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            tipText,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
          ),
        ),
      ],
    );
  }
}