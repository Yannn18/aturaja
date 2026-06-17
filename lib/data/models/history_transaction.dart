import 'package:flutter/material.dart';

class HistoryTransaction {
  final String id;
  final String description;
  final int amount;
  final DateTime createdAt;
  final String type;

  HistoryTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.type,
  });

  factory HistoryTransaction.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return HistoryTransaction(
      id: id,
      description: data['description'] ?? '',
      amount: data['amount'] ?? 0,
      type: data['type'] ?? 'income',
      createdAt:
          (data['created_at'] as dynamic).toDate(),
    );
  }

  IconData get icon {
    switch (type) {
      case 'income':
        return Icons.account_balance_wallet;
      default:
        return Icons.receipt;
    }
  }
}