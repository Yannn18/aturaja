import 'package:flutter/material.dart';

class ServiceItemModel {
  final String id;
  final String label;
  final String iconName; // Menyimpan nama string ikon (misal: 'bolt', 'phone')
  final String colorHex; // Menyimpan string kode warna HEX (misal: '0xFFFF9800')
  final bool isPromo;

  ServiceItemModel({
    required this.id,
    required this.label,
    required this.iconName,
    required this.colorHex,
    this.isPromo = false, // Default bernilai false jika tidak diisi
  });

  // Getter otomatis untuk mengubah string iconName menjadi IconData siap pakai di UI
  IconData get icon {
    switch (iconName) {
      case 'language': return Icons.language;
      case 'bolt': return Icons.bolt;
      case 'credit_card': return Icons.credit_card;
      case 'money': return Icons.money;
      case 'nightlight_round': return Icons.nightlight_round;
      case 'description': return Icons.description;
      case 'directions_car': return Icons.directions_car;
      case 'airplanemode_active': return Icons.airplanemode_active;
      default: return Icons.help_outline;
    }
  }

  // Getter otomatis untuk mengubah String HEX menjadi objek Color di Flutter
  Color get color => Color(int.parse(colorHex));

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      id: json['id'] as String,
      label: json['label'] as String,
      iconName: json['icon_name'] as String,
      colorHex: json['color_hex'] as String,
      isPromo: json['is_promo'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon_name': iconName,
      'color_hex': colorHex,
      'is_promo': isPromo,
    };
  }
}