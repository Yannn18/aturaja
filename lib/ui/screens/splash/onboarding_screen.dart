import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi warna konstan sesuai panduan merek AturAja
    const Color brandRed = Color(0xFFC61124);
    const Color bgColor = Color(0xFFFCF5F5);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // 1. HEADER (Logo & Tombol Lewati)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AturAja',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: brandRed,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigasi lewati onboarding langsung ke Dashboard/Login
                    },
                    child: Text(
                      'Lewati',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. VISUAL ILLUSTRATION (Grid 2x2)
            // ==========================================
            // Expanded memastikan ilustrasi mengambil sisa ruang yang ada di tengah
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildGridBox(color: const Color(0xFFF1B7B7)),
                        const SizedBox(width: 16),
                        _buildGridBox(color: const Color(0xFFF1B7B7)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildGridBox(color: const Color(0xFFE4E2E1)),
                        const SizedBox(width: 16),
                        _buildGridBox(
                          color: brandRed,
                          icon: Icons
                              .show_chart_rounded, // Ikon grafik tren bawaan Flutter
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // 3. BOTTOM WHITE CARD (Konten & Tombol)
            // ==========================================
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(24.0),
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), // Bayangan lembut
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pagination Dots (Indikator Halaman)
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 6,
                        decoration: BoxDecoration(
                          color: brandRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 6),
                      _buildDot(),
                      const SizedBox(width: 6),
                      _buildDot(),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Judul dengan Dua Warna (Menggunakan RichText)
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800, // Extra Bold
                        color: Colors.black,
                        height: 1.2, // Jarak antar baris
                      ),
                      children: [
                        TextSpan(text: 'Atur Anggaran\ndalam\n'),
                        TextSpan(
                          text: 'Sekejap.',
                          style: TextStyle(color: brandRed),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi Subtitle
                  Text(
                    'Gunakan fitur Smart Budgeting untuk menyusun rencana keuangan secara otomatis. Kelola pengeluaranmu lebih praktis dengan bantuan rekomendasi cerdas yang sesuai dengan kebutuhanmu.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Tombol Berikutnya
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // TODO: Pindah ke layar onboarding 2
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Berikutnya',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Komponen Helper untuk Kotak Visual
  Widget _buildGridBox({required Color color, IconData? icon}) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: icon != null ? Icon(icon, color: Colors.white, size: 45) : null,
    );
  }

  // Komponen Helper untuk Indikator Bulat Abu-abu
  Widget _buildDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}
