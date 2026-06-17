import 'package:aturaja/core/theme/app_theme.dart';
import 'package:aturaja/data/app_state.dart';
import 'package:flutter/material.dart';
import 'pin_verification_screen.dart';

class BudgetingNewScreen extends StatefulWidget {
  const BudgetingNewScreen({super.key});

  @override
  State<BudgetingNewScreen> createState() => _BudgetingNewScreenState();
}

class _BudgetingNewScreenState extends State<BudgetingNewScreen> {
  // ===========================
  // GLOBALKEY FORM
  // ===========================
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController nominalController = TextEditingController();

  final TextEditingController limitController = TextEditingController();

  final TextEditingController tujuanController = TextEditingController();

  final TextEditingController periodeController = TextEditingController();

  String selectedTujuan = 'Lainnya';

  final List<String> tujuanList = [
    'Lainnya',
    'Liburan',
    'Makanan',
    'Pendidikan',
    'Belanja',
  ];

  // ===========================
  // ICON SETIAP TUJUAN
  // ===========================
  final Map<String, IconData> tujuanIcons = {
    'Lainnya': Icons.category,
    'Liburan': Icons.flight,
    'Makanan': Icons.fastfood,
    'Pendidikan': Icons.school,
    'Belanja': Icons.shopping_bag,
  };

  @override
  Widget build(BuildContext context) {
    // ===========================
    // GLOBAL THEME
    // ===========================
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final budgetingTheme = Theme.of(context).extension<BudgetingInputTheme>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        // ===========================
        // SINGLECHILDSCROLLVIEW
        // Menghindari overflow
        // ===========================
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ===========================
                // HEADER
                // ===========================
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),

                      icon: Icon(
                        Icons.chevron_left,
                        size: 30,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        'Buat Alokasi Budget',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium,
                      ),
                    ),

                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 30),

                // ===========================
                // FOTO + FORM NAMA
                // Sesuai desain asli
                // ===========================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ===========================
                    // STACK + POSITIONED
                    // Memenuhi ketentuan tugas
                    // ===========================
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,

                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                        ),

                        Icon(
                          tujuanIcons[selectedTujuan],
                          size: 42,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),

                    const SizedBox(width: 28),

                    // ===========================
                    // FORM NAME
                    // ===========================
                    Expanded(
                      child: TextFormField(
                        controller: nameController,

                        decoration: budgetingTheme.underlineDecoration(
                          hintText: 'Name',
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }

                          if (value.length < 4) {
                            return 'Minimal 4 karakter';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ===========================
                // NOMINAL
                // ===========================
                Text('Nominal', style: textTheme.bodyMedium),

                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text('Rp', style: textTheme.headlineSmall),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextFormField(
                        controller: nominalController,

                        keyboardType: TextInputType.number,

                        decoration: budgetingTheme.underlineDecoration(
                          hintText: '',
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nominal wajib diisi';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ===========================
                // BATAS NOMINAL
                // ===========================
                Text('Batas Nominal', style: textTheme.bodyMedium),

                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text('Rp', style: textTheme.headlineSmall),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextFormField(
                        controller: limitController,

                        keyboardType: TextInputType.number,

                        decoration: budgetingTheme.underlineDecoration(
                          hintText: '',
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Batas nominal wajib diisi';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ===========================
                // SUMBER DANA
                // Border putih sesuai desain
                // ===========================
                Text('Sumber Dana', style: textTheme.bodyMedium),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text('Saldo Utama', style: textTheme.bodyMedium),

                      const SizedBox(height: 6),

                      ValueListenableBuilder<double>(
                        valueListenable: AppState.mainBalance,
                        builder: (context, balance, child) {
                          return Text(
                            AppState.formatRupiah(balance),
                            style: textTheme.headlineSmall,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ===========================
                // PERIODE
                // LABEL DIDALAM BORDER
                // ===========================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                    color: colorScheme.surface,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text('Periode', style: textTheme.bodySmall),

                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: () async {
                          final picked = await showDateRangePicker(
                            context: context,

                            firstDate: DateTime(2024),

                            lastDate: DateTime(2030),
                          );

                          if (picked != null) {
                            setState(() {
                              periodeController.text =
                                  '${picked.start.day}/${picked.start.month}/${picked.start.year} - ${picked.end.day}/${picked.end.month}/${picked.end.year}';
                            });
                          }
                        },

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              periodeController.text.isEmpty
                                  ? 'mm/dd/yyyy - mm/dd/yyyy'
                                  : periodeController.text,

                              style: textTheme.bodyMedium,
                            ),

                            Icon(Icons.date_range, color: colorScheme.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ===========================
                // TUJUAN ALOKASI
                // LABEL DIDALAM BORDER
                // ===========================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                    color: colorScheme.surface,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text('Tujuan Alokasi', style: textTheme.bodySmall),

                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedTujuan,

                          isExpanded: true,

                          items: tujuanList.map((item) {
                            return DropdownMenuItem(
                              value: item,

                              child: Text(item),
                            );
                          }).toList(),

                          onChanged: (value) {
                            setState(() {
                              selectedTujuan = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ===========================
                // BUTTON SIMPAN
                // ===========================
                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    // Cari bagian onPressed pada ElevatedButton "Simpan" Anda:
                    onPressed: () {
                      // 1. Jalankan Validasi Form (GlobalKey)
                      if (_formKey.currentState!.validate()) {
                        // 2. Kumpulkan data dari form (Kriteria Pengiriman Data/Argument Passing)
                        final budgetData = {
                          'name': nameController.text,
                          'nominal': nominalController.text,
                          'limit': limitController.text,
                          'tujuan': selectedTujuan,
                        };

                        // 3. Pindah ke halaman PIN dengan membawa data kustom di atas
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PinVerificationScreen(budgetData: budgetData),
                          ),
                        );
                      }
                    },

                    child: const Text('Simpan'),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
