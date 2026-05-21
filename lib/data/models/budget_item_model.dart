import 'package:flutter/material.dart';

/// Represents a single budget allocation for the app.
///
/// This model includes both the current spending and the total allocation,
/// plus a category lookup for a matching icon.
class BudgetItemModel {
  final String id;
  final String title;
  final int usedBudget;
  final int totalBudget;
  final String category;

  BudgetItemModel({
    required this.id,
    required this.title,
    required this.usedBudget,
    required this.totalBudget,
    required this.category,
  });

  /// Returns the budget usage percentage as a value between 0.0 and 1.0.
  ///
  /// If `totalBudget` is zero, this returns 0.0 to avoid a division by zero error.
  double get progress {
    if (totalBudget <= 0) {
      return 0.0;
    }

    return usedBudget / totalBudget;
  }

  /// Maps the budget category to a Material icon.
  ///
  /// This is useful for showing a category-specific symbol in the UI.
  IconData get icon {
    switch (category) {
      case 'Makanan':
        return Icons.fastfood;
      case 'Liburan':
        return Icons.flight;
      case 'Belanja':
        return Icons.shopping_bag;
      case 'Pendidikan':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  /// Creates a new BudgetItemModel from a JSON map.
  ///
  /// The JSON values are cast to the expected Dart types to keep the model
  /// strictly typed and null-safe.
  factory BudgetItemModel.fromJson(Map<String, dynamic> json) {
    return BudgetItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      usedBudget: json['usedBudget'] is int
          ? json['usedBudget'] as int
          : int.parse(json['usedBudget'].toString()),
      totalBudget: json['totalBudget'] is int
          ? json['totalBudget'] as int
          : int.parse(json['totalBudget'].toString()),
      category: json['category'] as String,
    );
  }

  /// Converts the model into a JSON map for storage or transport.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'usedBudget': usedBudget,
      'totalBudget': totalBudget,
      'category': category,
    };
  }
}
