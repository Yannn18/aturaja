import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

// Widget Kartu Saldo Kecil
class BalanceCard extends StatelessWidget {
  final String label;
  final String amount;

  const BalanceCard({super.key, required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
            const SizedBox(height: 2),
            Text(
              amount,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Aksi Cepat (Top Up, dll)
class QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  // Hapus isNotif dari sini
  const QuickActionItem({
    super.key, 
    required this.icon, 
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Kita tetap bisa menggunakan Stack jika suatu saat ingin menambah badge lagi,
        // atau bisa langsung menggunakan Container jika ingin lebih sederhana.
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.brandRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.brandRed, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.brandRed,
          ),
        ),
      ],
    );
  }
}

// Widget Item Layanan (Grid)
class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isPromo; // Tambahkan flag baru

  const ServiceItem({
    super.key, 
    required this.icon, 
    required this.label, 
    required this.color,
    this.isPromo = false, // Default false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            // Positioned: Label Promo
            if (isPromo)
              Positioned(
                top: -5,
                right: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PROMO',
                    style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

