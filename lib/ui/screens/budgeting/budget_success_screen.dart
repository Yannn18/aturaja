import 'package:aturaja/data/app_state.dart';
import 'package:aturaja/data/models/budget_item_model.dart';
import 'package:aturaja/data/repositories/budget_repository.dart';
import 'package:flutter/material.dart';

class BudgetSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> budgetData;

  const BudgetSuccessScreen({super.key, required this.budgetData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final String nominalString = budgetData['nominal'] ?? '0';
    // Mengambil data kiriman secara aman dengan fallback value jika kosong
    final String name = budgetData['name'] ?? 'Alokasi Baru';
    final String nominal = budgetData['nominal'] ?? '0';
    final String tujuan = budgetData['tujuan'] ?? 'Lainnya';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Spacer Atas agar posisi konten tengah seimbang
              const SizedBox(height: 20),

              // Bagian Konten Utama (Tengah)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ilustrasi Centang Sukses (Sesuai gambar acuan Anda)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Teks Judul Sukses
                  Text(
                    'Alokasi Berhasil Disetujui!',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Deskripsi Pendukung
                  Text(
                    'Budget kamu telah berhasil dialokasikan secara aman ke sub-wallet tujuan.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Kartu Rincian Alokasi (Card Detail)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Nama Alokasi', name, isBold: true),
                        const Divider(height: 24, thickness: 1),
                        _buildDetailRow('Tujuan', tujuan),
                        const Divider(height: 24, thickness: 1),
                        _buildDetailRow('Sumber Dana', 'Saldo Utama'),
                        const Divider(height: 24, thickness: 1),
                        _buildDetailRow(
                          'Total Nominal',
                          'Rp$nominal',
                          valueColor: Colors.green.shade700,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Bagian Tombol Bawah (Aksi Utama)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red.shade900, // Warna brand merah pekat AturAja
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  // Di dalam file budget_success_screen.dart pada bagian ElevatedButton:
                  onPressed: () async {
                    // 1. Tampilkan loading dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (loadingContext) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    final int amount = int.tryParse(
                          nominalString.replaceAll(RegExp(r'[^0-9]'), ''),
                        ) ??
                        0;

                    if (AppState.mainBalance.value < amount) {
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Saldo utama tidak cukup untuk membuat budget baru.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      return;
                    }

                    // 2. Potong saldo utama sesuai nominal budget
                    AppState.mainBalance.value -= amount;

                    // 3. Siapkan data object yang akan dikirim ke Firebase
                    final newBudget = BudgetItemModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: name,
                      usedBudget: 0,
                      totalBudget: amount,
                      category: tujuan,
                    );

                    try {
                      // 4. Eksekusi tembak data ke Firebase cloud
                      final BudgetRepository repo = BudgetRepository();
                      await repo.addBudget(newBudget);

                      // 5. SEBELUM pindah halaman, pastikan loading dialog ditutup duluan!
                      if (context.mounted) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(); // Menutup dialog loading secara spesifik
                      }

                      // 6. Kembalikan user ke halaman dashboard utama (Halaman Pertama)
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      }
                    } catch (e) {
                      // 6. Jika terjadi error, tutup loading dialog dan tampilkan SnackBar
                      if (context.mounted) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(); // Tutup loading

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Gagal sinkronisasi cloud: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Kembali ke Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Pembantu untuk Membuat Baris Rincian yang Rapi
  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black,
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
