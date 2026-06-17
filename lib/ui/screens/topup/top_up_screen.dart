import 'package:flutter/material.dart';
import '../../../data/app_state.dart';

// --- DATA MODELS (Tetap di atas atau di file terpisah) ---
class InstructionStep {
  final int number;
  final String text;
  final String? highlight;
  InstructionStep({required this.number, required this.text, this.highlight});
}

class PaymentMethod {
  final String id;
  final String name;
  final IconData icon;
  final String va;
  final List<InstructionStep> instructions;
  PaymentMethod({required this.id, required this.name, required this.icon, required this.va, required this.instructions});
}

class TopUpScreen extends StatefulWidget {
  final Function(String) onTopUpSuccess; // Ubah VoidCallback jadi Function(String)
  const TopUpScreen({super.key, required this.onTopUpSuccess});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  late List<PaymentMethod> _methods;
  late PaymentMethod _selectedMethod;

  @override
  void initState() {
    super.initState();
    _methods = [
      PaymentMethod(
        id: 'bca',
        name: 'Bank BCA',
        icon: Icons.account_balance,
        va: '12345 08123456789',
        instructions: [
          InstructionStep(number: 1, text: 'Masukkan kartu ATM dan PIN Anda dengan benar di mesin ATM BCA terdekat.'),
          InstructionStep(number: 2, text: 'Pilih menu Transaksi Lainnya > Transfer > Ke Rekening Virtual Account.'),
          InstructionStep(number: 3, text: 'Masukkan kode perusahaan AturAja (12345) diikuti nomor HP terdaftar Anda.', highlight: '(12345)'),
            InstructionStep(number: 4, text: 'Masukkan nominal top up yang Anda inginkan (Minimal Rp10.000).'),
            InstructionStep(number: 5, text: 'Ikuti instruksi selanjutnya pada layar ATM untuk menyelesaikan transaksi.'),

        ],
      ),
      PaymentMethod(
        id: 'alfamart',
        name: 'Alfamart',
        icon: Icons.store,
        va: '08123456789',
        instructions: [
          InstructionStep(number: 1, text: 'Kunjungi gerai Alfamart terdekat.'),
          InstructionStep(number: 2, text: 'Informasikan kepada kasir bahwa Anda ingin melakukan Top Up AturAja.'),
          InstructionStep(number: 3, text: 'Berikan nomor HP Anda kepada kasir.'),
          InstructionStep(number: 4, text: 'Sebutkan nominal top up yang diinginkan.'),
            InstructionStep(number: 5, text: 'Bayar sesuai nominal dan simpan struk pembayaran Anda.'),
        ],
      ),
      PaymentMethod(
        id: 'indomaret',
        name: 'Indomaret',
        icon: Icons.shopping_bag,
        va: '08123456789',
        instructions: [
          InstructionStep(number: 1, text: 'Kunjungi gerai Indomaret terdekat.'),
          InstructionStep(number: 2, text: 'Informasikan kepada kasir bahwa Anda ingin melakukan Top Up AturAja.'),
          InstructionStep(number: 3, text: 'Berikan nomor HP Anda kepada kasir.'),
          InstructionStep(number: 4, text: 'Sebutkan nominal top up yang diinginkan.'),
            InstructionStep(number: 5, text: 'Bayar sesuai nominal dan simpan struk pembayaran Anda.'),
        ],
      ),
      PaymentMethod(
        id: 'mandiri',
        name: 'Bank Mandiri',
        icon: Icons.account_balance_wallet,
        va: '54321 08123456789',
        instructions: [
          InstructionStep(number: 1, text: 'Login ke Livin\' by Mandiri.'),
          InstructionStep(number: 2, text: 'Pilih menu Bayar > Buat Pembayaran Baru > Multipayment.'),
          InstructionStep(number: 3, text: 'Pilih Penyedia Jasa "AturAja".'),
          InstructionStep(number: 4, text: 'Masukkan nomor Virtual Account.'),
          InstructionStep(number: 5, text: 'Konfirmasi dan masukkan PIN Mandiri Anda.'),
        ],
      ),
    ];
    _selectedMethod = _methods.first;
  }

  void _showAllMethods() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAllMethodsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text('Instruksi Top Up', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('ATURAJA', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Menghindari Overflow saat keyboard muncul atau konten panjang
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(primaryColor),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Metode Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                TextButton(
                  onPressed: _showAllMethods,
                  child: Text('Lihat Semua', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _methods.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _buildMethodButton(_methods[index]),
              ),
            ),
            const SizedBox(height: 32),
            _buildInstructionHeader(primaryColor),
            const SizedBox(height: 24),
            _buildInstructionList(primaryColor),
            const SizedBox(height: 16),
            _buildPromoBanner(primaryColor),
            const SizedBox(height: 40), // Spasi bawah agar tidak mentok
          ],
        ),
      ),
    );
  }

  Widget _buildMethodButton(PaymentMethod method) {
    bool isSelected = _selectedMethod.id == method.id;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        decoration: BoxDecoration(
          // PERBAIKAN 1: Jangan isi warna abu-abu penuh di sini
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            // PERBAIKAN 2: Jika tidak dipilih, border menjadi abu-abu
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              method.icon,
              // PERBAIKAN 3: Ikon berubah abu-abu jika tidak dipilih
              color: isSelected ? Colors.white : Colors.grey.shade400,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              method.name.split(' ').last,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                // PERBAIKAN 4: Teks berubah abu-abu jika tidak dipilih
                color: isSelected ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInstructionHeader(Color primaryColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
          child: Icon(Icons.info_outline, color: primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Langkah Top Up ${_selectedMethod.name}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('VA: ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  Text(_selectedMethod.va, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                  const Spacer(),
                  // BUNGKUS ICON COPY PAKAI INKWELL
                  InkWell(
                    onTap: () {
                      // 1. Update saldo di AppState (tambah 50.000)
                      AppState.mainBalance.value += 50000;

                      // 2. Kirim notifikasi
                      widget.onTopUpSuccess("Saldo berhasil ditambahkan ke akun AturAja kamu via ${_selectedMethod.name}.");

                      // 3. Feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Nomor VA disalin! Saldo via ${_selectedMethod.name} berhasil ditambahkan."),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Icon(Icons.copy, size: 18, color: primaryColor),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildInstructionList(Color primaryColor) {
    // Gunakan ListView.builder dengan shrinkWrap agar masuk ke SingleChildScrollView
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _selectedMethod.instructions.length,
      itemBuilder: (context, index) {
        final step = _selectedMethod.instructions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 2),
                ),
                child: Center(child: Text('${step.number}', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  step.text,
                  style: const TextStyle(color: Colors.black87, height: 1.4, fontWeight: FontWeight.w500)
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- WIDGET LAINNYA (Balance Card & Promo Banner Tetap) ---
  Widget _buildBalanceCard(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Saldo Saat Ini', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          // BUNGKUS DENGAN ValueListenableBuilder AGAR DINAMIS
          ValueListenableBuilder<double>(
            valueListenable: AppState.mainBalance,
            builder: (context, balance, child) {
              return Text(
                AppState.formatRupiah(balance),
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
              );
            },
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text('Transaksi Aman', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryColor, Colors.black87]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        'Bebas Biaya Admin via ${_selectedMethod.name}!',
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
      ),
    );
  }

  Widget _buildAllMethodsSheet() {
    return Container(
      // Batasi tinggi modal agar tidak overflow ke atas layar
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2))),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Align(alignment: Alignment.centerLeft, child: Text('Metode Lainnya', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
          ),
          Flexible( // Gunakan Flexible agar list di dalam modal bisa di-scroll
            child: ListView(
              shrinkWrap: true,
              children: _methods.map((m) => ListTile(
                leading: Icon(m.icon, color: Theme.of(context).primaryColor),
                title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(Icons.circle, color: _selectedMethod.id == m.id ? Theme.of(context).primaryColor : Colors.grey, size: 12),
                onTap: () {
                  setState(() => _selectedMethod = m);
                  Navigator.pop(context);
                },
              )).toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}