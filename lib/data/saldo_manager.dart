import 'package:flutter/material.dart';

class SaldoManager {
  // Saldo awal disetel ke Rp 5.200.000
  static final ValueNotifier<int> totalSaldo = ValueNotifier<int>(5200000);

  // Fungsi untuk menambah saldo secara instan
  static void tambahDana(int jumlah) {
    totalSaldo.value += jumlah;
  }

  // Fungsi bantuan untuk mengubah angka menjadi format titik (Ribuan)
  static String formatRupiah(int angka) {
    return angka.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}