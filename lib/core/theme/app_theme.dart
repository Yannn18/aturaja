import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primarySeed,
        primary: AppColors.brandRed,
        secondary: AppColors.successGreen,
      ),
      // Mengatur warna background seluruh layar
      scaffoldBackgroundColor: AppColors.surfaceWhite,

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.brandRed, width: 1.5),
        ),
      ),
      
      // ===========================
// THEME KHUSUS UNDERLINE INPUT
// Untuk budgeting_new_screen
// ===========================
extensions: <ThemeExtension<dynamic>>[
  const BudgetingInputTheme(),
],

      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        labelLarge: TextStyle(fontWeight: FontWeight.bold),
      ),

      // Mengatur tema AppBar secara global
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.brandRed),
      ),

      // Mengatur font default (Inter/San Francisco jika sudah diinstall)
      fontFamily: 'Inter',

      // Mengatur tema default untuk Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFF3F3F3),

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        margin: const EdgeInsets.only(bottom: 18),
      ),

      // ===========================
      // FAB THEME
      // ===========================
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        backgroundColor: AppColors.brandRed,
        foregroundColor: Colors.white,
      ),
    );
  }
}
// ===========================
// CUSTOM THEME EXTENSION
// ===========================
@immutable
class BudgetingInputTheme
    extends ThemeExtension<BudgetingInputTheme> {

  const BudgetingInputTheme();

  InputDecoration underlineDecoration({
    required String hintText,
  }) {

    return InputDecoration(
      hintText: hintText,

      filled: false,

      contentPadding:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),

      border: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF767676),
        ),
      ),

      enabledBorder:
          const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF767676),
        ),
      ),

      focusedBorder:
          const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.brandRed,
          width: 2,
        ),
      ),
    );
  }

  InputDecoration outlineDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {

    return InputDecoration(
      hintText: hintText,

      filled: false,

      suffixIcon: suffixIcon,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),

        borderSide: BorderSide(
          color: Colors.grey.shade500,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),

        borderSide: const BorderSide(
          color: AppColors.brandRed,
          width: 2,
        ),
      ),
    );
  }

  @override
  ThemeExtension<BudgetingInputTheme>
      copyWith() {
    return const BudgetingInputTheme();
  }

  @override
  ThemeExtension<BudgetingInputTheme> lerp(
    covariant ThemeExtension<BudgetingInputTheme>? other,
    double t,
  ) {
    return this;
  }
}