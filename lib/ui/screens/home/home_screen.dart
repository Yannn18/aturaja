import 'package:flutter/material.dart';
import '../../widgets/home_widgets.dart'; // Import widget kustom kita

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tambahkan Scaffold agar layout aman
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Header Section
            _buildHeader(context),

            // 2. Saldo Section
            _buildBalanceSection(context),

            // 3. Budgeting Button
            _buildBudgetingButton(context),

            // 4. Quick Actions
            _buildQuickActions(context),

            const SizedBox(height: 0),

            // 5. Services Grid
            _buildServicesGrid(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Pisahkan tiap bagian ke dalam Method agar build() tidak terlalu panjang
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        40,
        16,
        0,
      ), // Atur top padding untuk status bar
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
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hai, Mario',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                BalanceCard(label: 'Saldo Utama', amount: 'Rp5,200,000'),
                SizedBox(width: 12),
                BalanceCard(label: 'Saldo Makanan', amount: 'Rp80,000'),
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
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withAlpha((0.1 * 255).round()),
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
    );
  }

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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QuickActionItem(icon: Icons.add_circle_outline, label: 'Top Up'),
            QuickActionItem(icon: Icons.send_outlined, label: 'Transfer'),
            QuickActionItem(icon: Icons.pie_chart_outline, label: 'Rekap'),
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
          ServiceItem(
            icon: Icons.language,
            label: 'Pulsa data',
            color: Colors.red,
          ),
          ServiceItem(icon: Icons.bolt, label: 'Listrik', color: Colors.orange),
          ServiceItem(
            icon: Icons.credit_card,
            label: 'Kartu Uang',
            color: Colors.red,
          ),
          ServiceItem(
            icon: Icons.money,
            label: 'Pinjaman',
            color: Colors.orange,
            isPromo: true,
          ),
          ServiceItem(
            icon: Icons.nightlight_round,
            label: 'Infaq',
            color: Colors.blue,
          ),
          ServiceItem(
            icon: Icons.description,
            label: 'LinkAja Deals',
            color: Colors.blue,
            isPromo: true,
          ),
          ServiceItem(
            icon: Icons.directions_car,
            label: 'Parkir',
            color: Colors.blue,
          ),
          ServiceItem(
            icon: Icons.airplanemode_active,
            label: 'Pesawat',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
