import 'package:flutter/material.dart';

class BudgetingNewScreen extends StatefulWidget {
  const BudgetingNewScreen({super.key});

  @override
  State<BudgetingNewScreen> createState() =>
      _BudgetingNewScreenState();
}

class _BudgetingNewScreenState
    extends State<BudgetingNewScreen> {

  // ===========================
  // GLOBALKEY FORM
  // Memenuhi ketentuan:
  // - Form Validation
  // ===========================
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController nominalController =
      TextEditingController();

  final TextEditingController limitController =
      TextEditingController();

  final TextEditingController tujuanController =
      TextEditingController();

  final TextEditingController periodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    // ===========================
    // GLOBAL THEME
    // ===========================
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(

        // ===========================
        // SINGLECHILDSCROLLVIEW
        // Menghindari overflow
        // ===========================
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // ===========================
                // HEADER
                // ===========================
                Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          Navigator.pop(context),

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

                        style: textTheme.titleLarge
                            ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 30),

                // ===========================
                // STACK + POSITIONED
                // Memenuhi ketentuan tugas
                // ===========================
                Center(
                  child: Stack(
                    alignment: Alignment.center,

                    children: [

                      // Circle Background
                      Container(
                        width: 90,
                        height: 90,

                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                      ),

                      // Icon
                      Icon(
                        Icons.wallet,
                        size: 42,
                        color: colorScheme.primary,
                      ),

                      // Positioned Badge
                      Positioned(
                        bottom: 2,
                        right: 2,

                        child: Container(
                          padding:
                              const EdgeInsets.all(6),

                          decoration:
                              BoxDecoration(
                            color:
                                colorScheme.primary,
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ===========================
                // NAMA BUDGET
                // ===========================
                Text(
                  'Nama Budget',
                  style: textTheme.bodyMedium,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: nameController,

                  decoration:
                      const InputDecoration(
                    hintText: 'Masukkan nama budget',
                  ),

                  // ===========================
                  // VALIDASI FORM
                  // ===========================
                  validator: (value) {

                    if (value == null ||
                        value.isEmpty) {
                      return
                          'Nama budget tidak boleh kosong';
                    }

                    if (value.length < 4) {
                      return
                          'Minimal 4 karakter';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // ===========================
                // NOMINAL
                // ===========================
                Text(
                  'Nominal',
                  style: textTheme.bodyMedium,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: nominalController,
                  keyboardType:
                      TextInputType.number,

                  decoration:
                      const InputDecoration(
                    prefixText: 'Rp ',
                    hintText:
                        'Masukkan nominal',
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.isEmpty) {
                      return
                          'Nominal tidak boleh kosong';
                    }

                    if (value.length < 5) {
                      return
                          'Minimal 5 digit';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // ===========================
                // BATAS NOMINAL
                // ===========================
                Text(
                  'Batas Nominal',
                  style: textTheme.bodyMedium,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: limitController,
                  keyboardType:
                      TextInputType.number,

                  decoration:
                      const InputDecoration(
                    prefixText: 'Rp ',
                    hintText:
                        'Masukkan batas nominal',
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.isEmpty) {
                      return
                          'Batas nominal tidak boleh kosong';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // ===========================
                // SUMBER DANA CARD
                // Menggunakan global CardTheme
                // ===========================
                Text(
                  'Sumber Dana',
                  style: textTheme.bodyMedium,
                ),

                const SizedBox(height: 10),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(20),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(
                          'Saldo Utama',
                          style: textTheme
                              .bodyMedium,
                        ),

                        const SizedBox(
                            height: 8),

                        Text(
                          'Rp5,200,000',

                          style: textTheme
                              .headlineSmall
                              ?.copyWith(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ===========================
                // PERIODE
                // ===========================
                Text(
                  'Periode',
                  style: textTheme.bodyMedium,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller:
                      periodeController,

                  readOnly: true,

                  decoration:
                      const InputDecoration(
                    hintText:
                        'mm/dd/yyyy - mm/dd/yyyy',

                    suffixIcon:
                        Icon(Icons.date_range),
                  ),

                  onTap: () async {

                    final picked =
                        await showDateRangePicker(
                      context: context,

                      firstDate:
                          DateTime(2024),

                      lastDate:
                          DateTime(2030),
                    );

                    if (picked != null) {

                      setState(() {

                        periodeController.text =
                            '${picked.start.day}/${picked.start.month}/${picked.start.year} - ${picked.end.day}/${picked.end.month}/${picked.end.year}';
                      });
                    }
                  },

                  validator: (value) {

                    if (value == null ||
                        value.isEmpty) {
                      return
                          'Periode wajib dipilih';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // ===========================
                // TUJUAN ALOKASI
                // ===========================
                Text(
                  'Tujuan Alokasi',
                  style: textTheme.bodyMedium,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller:
                      tujuanController,

                  decoration:
                      const InputDecoration(
                    hintText:
                        'Contoh: Liburan, Pendidikan',
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.isEmpty) {
                      return
                          'Tujuan alokasi wajib diisi';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // ===========================
                // BUTTON SIMPAN
                // ===========================
                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(

                    onPressed: () {

                      // ===========================
                      // VALIDASI FORM
                      // ===========================
                      if (_formKey.currentState!
                          .validate()) {

                        // ===========================
                        // FEEDBACK SNACKBAR
                        // ===========================
                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Budget berhasil dibuat',
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      }
                    },

                    child: const Text(
                      'Simpan',
                    ),
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