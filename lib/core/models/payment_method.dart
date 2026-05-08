import 'package:flutter/material.dart';

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

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.va,
    required this.instructions,
  });
}