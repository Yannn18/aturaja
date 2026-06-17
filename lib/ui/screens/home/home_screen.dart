import 'package:flutter/material.dart';
import '../../../data/app_state.dart';
import '../../widgets/home_widgets.dart'; // Import widget kustom kita
import '../topup/top_up_screen.dart'; // Import halaman Top Up

class HomeScreen extends StatefulWidget {
  final Function(String) onBalanceUpdated; // Ubah VoidCallback jadi Function(String)
  const HomeScreen({super.key, required this.onBalanceUpdated});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context),
            _buildBalanceSection(context),
            _buildBudgetingButton(context),
            _buildQuickActions(context), // Ini yang tadi dibilang error (karena fungsinya sempat hilang)
            const SizedBox(height: 0),
            _buildServicesGrid(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'AturAja !',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hai, Mario', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                ValueListenableBuilder<double>(
                  valueListenable: AppState.mainBalance,
                  builder: (context, balance, child) {
                    return BalanceCard(label: 'Saldo Utama', amount: AppState.formatRupiah(balance));
                  },
                ),
                const SizedBox(width: 12),
                const BalanceCard(label: 'Saldo Makanan', amount: 'Rp80,000'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetingButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Transform.translate(
        offset: const Offset(0, -15),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, '/budgeting');
          },
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha((0.1 * 255).round()),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Budgeting',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // INI FUNGSI YANG TADI HILANG
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withAlpha((0.1 * 255).round()),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QuickActionItem(
              icon: Icons.add_circle_outline,
              label: 'Top Up',
              onTap: () {
                // Navigasi ke TopUpScreen dan kirim fungsi notifikasinya
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopUpScreen(onTopUpSuccess: widget.onBalanceUpdated),
                  ),
                );
              },
            ),
            const QuickActionItem(icon: Icons.send_outlined, label: 'Transfer'),
            const QuickActionItem(icon: Icons.pie_chart_outline, label: 'Rekap'),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisExtent: 85,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: const [
          ServiceItem(icon: Icons.language, label: 'Pulsa data', color: Colors.red),
          ServiceItem(icon: Icons.bolt, label: 'Listrik', color: Colors.orange),
          ServiceItem(icon: Icons.credit_card, label: 'Kartu Uang', color: Colors.red),
          ServiceItem(icon: Icons.money, label: 'Pinjaman', color: Colors.orange, isPromo: true),
          ServiceItem(icon: Icons.nightlight_round, label: 'Infaq', color: Colors.blue),
          ServiceItem(icon: Icons.description, label: 'LinkAja Deals', color: Colors.blue, isPromo: true),
          ServiceItem(icon: Icons.directions_car, label: 'Parkir', color: Colors.blue),
          ServiceItem(icon: Icons.airplanemode_active, label: 'Pesawat', color: Colors.blue),
        ],
      ),
    );
  }
}