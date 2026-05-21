import 'package:aturaja/data/models/budget_item_model.dart';
import 'package:aturaja/data/repositories/budget_repository.dart';
import 'package:flutter/material.dart';

class BudgetingScreen extends StatefulWidget {
  const BudgetingScreen({super.key});

  @override
  State<BudgetingScreen> createState() => _BudgetingScreenState();
}

class _BudgetingScreenState extends State<BudgetingScreen> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final totalSaldo = 5200000;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // FAB Thumb Zone
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.chevron_left,
                      color: colorScheme.onSurface,
                      size: 30,
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'Budgeting',
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),
            ),

            // BODY
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // SALDO CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: colorScheme.outline,
                          width: 2,
                        ),
                      ),

                      child: Column(
                        children: [
                          Text(
                            'Rp${totalSaldo.toString()}',
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Total saldo utama',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Di dalam file budgeting_screen.dart pada bagian DYNAMIC LIST menggantikan ListView lama:
                    // ===========================================================
                    // DYNAMIC LIST - MEMBACA CLOUD FIRESTORE
                    // ===========================================================
                    Expanded(
                      // Memastikan daftar mengambil ruang layar secara optimal
                      child: FutureBuilder<List<BudgetItemModel>>(
                        future: BudgetRepository()
                            .getBudgets(), // Mengetuk pintu server Firebase
                        builder: (context, snapshot) {
                          // 1. Kondisi saat aplikasi menunggu sinyal internet dari Google
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          // 2. Kondisi jika terjadi gangguan sinyal atau koleksi 'budgets' di Firebase masih kosong
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                "Belum ada alokasi budget di cloud.",
                                style: textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          // 3. Data berhasil dikonversi dari JSON menjadi Object Dart secara aman
                          final List<BudgetItemModel> budgetsFromServer =
                              snapshot.data!;

                          // 4. Gambar daftar kartu secara dinamis sesuai jumlah data di internet
                          return ListView.builder(
                            itemCount: budgetsFromServer.length,
                            padding: const EdgeInsets.only(bottom: 16),
                            itemBuilder: (context, index) {
                              final item = budgetsFromServer[index];
                              return BudgetCard(
                                item: item,
                              ); // Mengirim data model ke kartu kustom Anda
                            },
                          );
                        },
                      ),
                    ),

                    // ===========================
                    // ADD NEW BUTTON
                    // Ikut scroll bersama content
                    // ===========================
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 24),

                      child: SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton.icon(
                          // Ubah bagian onPressed tombol 'Add New' Anda menjadi async:
                          onPressed: () async {
                            // Tunggu sampai user menyelesaikan seluruh alur form, PIN, dan sukses
                            await Navigator.pushNamed(
                              context,
                              '/budgeting-new',
                            );

                            // Begitu user kembali ke halaman ini, paksa jalankan setState untuk memicu FutureBuilder mereload data baru Firebase
                            setState(() {});
                          },

                          icon: const Icon(Icons.add),

                          label: const Text(
                            'Add New',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetCard extends StatefulWidget {
  final BudgetItemModel item;

  const BudgetCard({super.key, required this.item});

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Icon(
                    widget.item.icon,
                    size: 34,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text('Sisa Saldo', style: textTheme.bodySmall),

                      const SizedBox(height: 4),

                      Text(
                        'Rp${widget.item.usedBudget}/ Rp${widget.item.totalBudget}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? 'Budget ditambahkan ke favorit'
                              : 'Budget dihapus dari favorit',
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? Colors.red
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                minHeight: 14,
                value: widget.item.progress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
