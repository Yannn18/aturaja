import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../core/constants/colors.dart';
import 'history_details_screen.dart';

class Transaction {
  final String id;
  final String category;
  final String time;
  final String amount;
  final String date;
  final IconData icon;

  Transaction({
    required this.id,
    required this.category,
    required this.time,
    required this.amount,
    required this.date,
    required this.icon,
  });
}

final List<Transaction> allTransactions = [
  // --- Bulan April (Apr) ---
  Transaction(
    id: '1',
    category: 'Makanan',
    time: '12:30',
    amount: 'Rp 50.000',
    date: '8 Apr 2025',
    icon: Icons.fastfood,
  ),
  Transaction(
    id: '2',
    category: 'Transportasi',
    time: '09:15',
    amount: 'Rp 25.000',
    date: '8 Apr 2025',
    icon: Icons.directions_car,
  ),
  Transaction(
    id: '3',
    category: 'Belanja',
    time: '16:45',
    amount: 'Rp 150.000',
    date: '7 Apr 2025',
    icon: Icons.shopping_bag,
  ),

  // --- Bulan Mei (Mei) ---
  Transaction(
    id: '4',
    category: 'Tagihan Internet',
    time: '10:00',
    amount: 'Rp 350.000',
    date: '15 Mei 2025',
    icon: Icons.wifi,
  ),
  Transaction(
    id: '5',
    category: 'Listrik',
    time: '14:20',
    amount: 'Rp 200.000',
    date: '2 Mei 2025',
    icon: Icons.electrical_services,
  ),

  // --- Bulan Juni (Jun) ---
  Transaction(
    id: '6',
    category: 'Nonton Bioskop',
    time: '19:30',
    amount: 'Rp 100.000',
    date: '20 Jun 2025',
    icon: Icons.movie,
  ),
  Transaction(
    id: '7',
    category: 'Makan Malam',
    time: '20:15',
    amount: 'Rp 75.000',
    date: '12 Jun 2025',
    icon: Icons.restaurant,
  ),
  Transaction(
    id: '8',
    category: 'Top Up E-Wallet',
    time: '08:00',
    amount: 'Rp 50.000',
    date: '5 Jun 2025',
    icon: Icons.account_balance_wallet,
  ),

  // --- Bulan Juli (July) ---
  Transaction(
    id: '9',
    category: 'Beli Pakaian',
    time: '15:40',
    amount: 'Rp 250.000',
    date: '25 July 2025',
    icon: Icons.checkroom,
  ),
  Transaction(
    id: '10',
    category: 'Ojek Online',
    time: '17:10',
    amount: 'Rp 30.000',
    date: '10 July 2025',
    icon: Icons.two_wheeler,
  ),

  // --- Bulan Agustus (Aug) ---
  Transaction(
    id: '11',
    category: 'Belanja Bulanan',
    time: '11:00',
    amount: 'Rp 120.000',
    date: '18 Aug 2025',
    icon: Icons.local_grocery_store,
  ),
  Transaction(
    id: '12',
    category: 'Apotek',
    time: '09:30',
    amount: 'Rp 80.000',
    date: '3 Aug 2025',
    icon: Icons.medical_services,
  ),
];

class HistoryScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const HistoryScreen({super.key, this.onBack});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<String> months = ['Apr', 'Mei', 'Jun', 'July', 'Aug'];
  String activeMonth = 'Apr';

  @override
  Widget build(BuildContext context) {
    final currentMonthTransactions = allTransactions
        .where((tx) => tx.date.contains(activeMonth))
        .toList();

    // Ambil daftar tanggal unik dari transaksi bulan ini (untuk membuat header tanggal)
    final uniqueDates = currentMonthTransactions
        .map((tx) => tx.date)
        .toSet()
        .toList();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            //header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack ?? () => Navigator.pop(context),
                      icon: Icon(
                        Icons.chevron_left,
                        size: 32,
                        color: Colors.grey[900],
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 24,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Draggable Sheet (Bisa ditarik atas bawah)
            DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 1.0,
              snap: true,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        offset: const Offset(0, -4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  // 1. UBAH COLUMN MENJADI LISTVIEW
                  child: ListView(
                    controller: scrollController, // 2. PASANG CONTROLLER DI SINI
                    padding: EdgeInsets.zero, // Hilangkan padding bawaan ListView
                    children: [
                      const SizedBox(height: 24),
                      // Drag Handle
                      Center(
                        child: Container(
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Semua Transaksi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Horizontal Months List
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: months.map((month) {
                            final isActive = activeMonth == month;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    activeMonth = month;
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? AppColors.brandRed
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    month,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isActive
                                          ? Colors.white
                                          : Colors.grey[900],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Transactions List
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey[100]!),
                          ),
                        ),
                        child: uniqueDates.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 60),
                                child: Center(
                                  child: Text(
                                    "Tidak ada transaksi",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                // 3. HAPUS CONTROLLER DARI SINI
                                padding: const EdgeInsets.only(top: 8, bottom: 24),
                                shrinkWrap: true, // 4. WAJIB ADA (karena di dalam ListView lain)
                                physics: const NeverScrollableScrollPhysics(), // 5. WAJIB ADA agar tidak bentrok
                                itemCount: uniqueDates.length,
                                itemBuilder: (context, index) {
                                  final date = uniqueDates[index];
                                  final items = currentMonthTransactions
                                      .where((t) => t.date == date)
                                      .toList();

                                  return TransactionGroup(
                                    date: date,
                                    items: items,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionGroup extends StatelessWidget {
  final String date;
  final List<Transaction> items;

  const TransactionGroup({Key? key, required this.date, required this.items})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
              ),
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return AnimatedTransactionButton(item: items[index]);
            },
          ),
        ],
      ),
    );
  }
}

class AnimatedTransactionButton extends StatefulWidget {
  final Transaction item;

  const AnimatedTransactionButton({Key? key, required this.item})
    : super(key: key);

  @override
  State<AnimatedTransactionButton> createState() =>
      _AnimatedTransactionButtonState();
}

class _AnimatedTransactionButtonState extends State<AnimatedTransactionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        // Aksi saat transaksi diklik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TransactionDetailScreen(transaction: widget.item),
          ),
        );
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.grey[50] : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // 1. Ikon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.item.icon,
                    color: AppColors.brandRed,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // 2. Teks Kategori & Waktu dibungkus Expanded
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.category,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                          fontSize: 14,
                        ),
                        maxLines: 1, // Membatasi teks hanya 1 baris
                        overflow: TextOverflow.ellipsis, // Menambahkan "..." jika teks terlalu panjang
                      ),
                      const SizedBox(height: 2), // Sedikit jarak antar teks
                      Text(
                        widget.item.time,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                Text(
                  widget.item.amount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
