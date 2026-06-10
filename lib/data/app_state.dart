import 'package:flutter/material.dart';

/// Global State Sederhana untuk kebutuhan simulasi UI
class AppState {
  // Menyimpan saldo utama dengan nilai awal 5.200.000
  static final ValueNotifier<double> mainBalance = ValueNotifier<double>(
    5200000,
  );

  // Fungsi helper untuk mengubah angka menjadi format Rupiah (tanpa package intl)
  static String formatRupiah(double amount) {
    String result = amount.toInt().toString();
    String formatted = '';
    int count = 0;
    for (int i = result.length - 1; i >= 0; i--) {
      formatted = result[i] + formatted;
      count++;
      if (count == 3 && i != 0) {
        formatted = '.$formatted';
        count = 0;
      }
    }
    return 'Rp$formatted';
  }
}
