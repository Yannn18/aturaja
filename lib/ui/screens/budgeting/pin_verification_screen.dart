import 'package:flutter/material.dart';
import 'budget_success_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  final Map<String, dynamic>
  budgetData; // Menerima data kiriman dari form sebelumnya

  const PinVerificationScreen({super.key, required this.budgetData});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  String _pin = "";
  final int _pinLength =
      6; // Mengatur jumlah digit PIN (Sesuaikan jika ingin 4 atau 6)

  void _onKeyPress(String val) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += val;
      });
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _handleVerification() {
    if (_pin.length == _pinLength) {
      // Melakukan push halaman sukses dan menggantikan halaman PIN saat ini (agar user tidak bisa kembali ke halaman PIN dengan tombol back)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BudgetSuccessScreen(budgetData: widget.budgetData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header: Tombol Back
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 16.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            const Spacer(),

            // Judul Teks
            const Text(
              'Masukin PIN kamu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 40),

            // Baris Indikator Titik PIN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pinLength,
                (index) => _buildPinDot(index),
              ),
            ),

            const Spacer(),

            // Tombol "Lanjutkan"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red.shade900, // Warna brand merah pekat
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _pin.length == _pinLength
                      ? _handleVerification
                      : null,
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Custom Numeric Keyboard (Keyboard Angka Kustom)
            _buildKeyboard(),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Widget Pembuat Titik PIN (Dot)
  Widget _buildPinDot(int index) {
    bool isFilled = index < _pin.length;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isFilled
                ? Colors.black
                : Colors.transparent, // Berubah hitam jika diisi
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  // Widget Susunan Keyboard Grid
  Widget _buildKeyboard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
              ), // Spacer penyeimbang tombol 0
              _buildKey('0'),
              _buildBackspaceKey(),
            ],
          ),
        ],
      ),
    );
  }

  // Tombol Angka Individual
  Widget _buildKey(String value) {
    return InkWell(
      onTap: () => _onKeyPress(value),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // Tombol Backspace (Hapus)
  Widget _buildBackspaceKey() {
    return InkWell(
      onTap: _onBackspace,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: const Icon(
          Icons.backspace_outlined,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }
}
