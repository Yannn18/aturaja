import 'package:flutter/material.dart';

class BudgetItem {
  final String id;
  final String title;
  final int usedBudget;
  final int totalBudget;
  final IconData icon;

  BudgetItem({
    required this.id,
    required this.title,
    required this.usedBudget,
    required this.totalBudget,
    required this.icon,
  });

  double get progress => usedBudget / totalBudget;
}

final List<BudgetItem> allBudgets = [
  BudgetItem(
    id: '1',
    title: 'Makanan Card 1',
    usedBudget: 20000,
    totalBudget: 50000,
    icon: Icons.fastfood,
  ),
  BudgetItem(
    id: '2',
    title: 'Makanan Card 2',
    usedBudget: 30000,
    totalBudget: 50000,
    icon: Icons.restaurant,
  ),
  BudgetItem(
    id: '3',
    title: 'Transportasi',
    usedBudget: 40000,
    totalBudget: 100000,
    icon: Icons.directions_car,
  ),
  BudgetItem(
    id: '4',
    title: 'Belanja',
    usedBudget: 150000,
    totalBudget: 300000,
    icon: Icons.shopping_bag,
  ),
  BudgetItem(
    id: '5',
    title: 'Internet',
    usedBudget: 250000,
    totalBudget: 350000,
    icon: Icons.wifi,
  ),
  BudgetItem(
    id: '6',
    title: 'Listrik',
    usedBudget: 180000,
    totalBudget: 300000,
    icon: Icons.electrical_services,
  ),
  BudgetItem(
    id: '7',
    title: 'Hiburan',
    usedBudget: 50000,
    totalBudget: 120000,
    icon: Icons.movie,
  ),
  BudgetItem(
    id: '8',
    title: 'Kesehatan',
    usedBudget: 70000,
    totalBudget: 100000,
    icon: Icons.medical_services,
  ),
  BudgetItem(
    id: '9',
    title: 'Ojek Online',
    usedBudget: 25000,
    totalBudget: 70000,
    icon: Icons.two_wheeler,
  ),
  BudgetItem(
    id: '10',
    title: 'E-Wallet',
    usedBudget: 50000,
    totalBudget: 150000,
    icon: Icons.account_balance_wallet,
  ),
];

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddBudgetDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add New"),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
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

                    // STACK + POSITIONED
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Row(
                            children: [
                              Icon(
                                Icons.notifications_active,
                                color: colorScheme.primary,
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  '2 Budget hampir melewati batas',
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // LIST TITLE
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daftar Budget',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          '${allBudgets.length} Items',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // DYNAMIC LIST
                    Expanded(
                      child: ListView.builder(
                        itemCount: allBudgets.length,
                        itemBuilder: (context, index) {
                          final item = allBudgets[index];

                          return BudgetCard(item: item);
                        },
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
  final BudgetItem item;

  const BudgetCard({
    super.key,
    required this.item,
  });

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

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),

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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Sisa Saldo',
                      style: textTheme.bodySmall,
                    ),

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
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
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
    );
  }
}

class AddBudgetDialog extends StatefulWidget {
  const AddBudgetDialog({super.key});

  @override
  State<AddBudgetDialog> createState() =>
      _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController amountController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Budget'),

      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Nama Budget',
              ),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama budget tidak boleh kosong';
                }

                if (value.length < 4) {
                  return 'Minimal 4 karakter';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Budget',
              ),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah budget tidak boleh kosong';
                }

                if (value.length < 5) {
                  return 'Minimal 5 digit';
                }

                return null;
              },
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),

        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Budget baru berhasil ditambahkan'),
                ),
              );
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}