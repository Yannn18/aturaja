class TransactionModel {
  final String id;
  final String userId;
  final String walletId;
  final String? budgetId;
  final int amount;
  final String type;
  final String description;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.walletId,
    this.budgetId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
  }) : assert(
         type == 'income' || type == 'expense',
         "type must be 'income' or 'expense'",
       );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['createdAt'];

    return TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      walletId: json['walletId'] as String,
      budgetId: json['budgetId'] as String?,
      amount: json['amount'] is int
          ? json['amount'] as int
          : int.parse(json['amount'].toString()),
      type: json['type'] as String,
      description: json['description'] as String,
      createdAt: createdAtValue is DateTime
          ? createdAtValue
          : DateTime.parse(createdAtValue as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'walletId': walletId,
      'budgetId': budgetId,
      'amount': amount,
      'type': type,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
