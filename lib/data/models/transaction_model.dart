class TransactionModel {
  final String id;
  final String userId;
  final String walletId;
  final String? budgetId; // Menggunakan tanda '?' karena bisa bernilai null
  final int amount;       // Wajib 'int' untuk nominal Rupiah
  final String type;      // Nilainya: 'income' atau 'expense'
  final String description;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.walletId,
    this.budgetId, // Tidak wajib diisi jika transaksi umum
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      walletId: json['wallet_id'] as String,
      budgetId: json['budget_id'] as String?, // Menangani null secara aman
      amount: json['amount'] as int,
      type: json['type'] as String,
      description: json['description'] as String,
      // Konversi teks String ISO atau Timestamp dari database menjadi DateTime Dart
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'wallet_id': walletId,
      'budget_id': budgetId,
      'amount': amount,
      'type': type,
      'description': description,
      // Mengubah DateTime menjadi teks String standar ISO 8601 untuk database
      'created_at': createdAt.toIso8601String(),
    };
  }
}