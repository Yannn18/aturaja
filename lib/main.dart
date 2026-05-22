import 'dart:async';

import 'package:aturaja/ui/screens/app.dart';
import 'package:aturaja/ui/screens/budgeting/budgeting_new_screen.dart';
import 'package:aturaja/ui/screens/budgeting/budgeting_screen.dart';
import 'package:aturaja/ui/screens/history/history_screen.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/screens/login/login_screen.dart';
import 'ui/screens/signup/sign_up_screen.dart';
import 'ui/screens/topup/top_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'ui/screens/onboarding/onboarding_screen.dart';
import 'ui/screens/auth/verify_identity_screen.dart';
import 'ui/screens/auth/ktp_scanner_screen.dart';
import 'ui/screens/auth/confirm_ktp_screen.dart';
import 'ui/screens/auth/face_scanner_screen.dart';
import 'ui/screens/auth/confirm_selfie_screen.dart';
import 'ui/screens/auth/data_personal_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print("=== START INITIALIZATION ===");

    // 2. Inisialisasi Firebase dengan batas waktu (timeout) agar tidak menggantung selamanya
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException(
          "Koneksi ke Firebase terlalu lama (Timeout 10 detik).",
        );
      },
    );

    print("=== FIREBASE INITIALIZED SUCCESSFULLY ===");
  } catch (e) {
    // Jika Firebase gagal/timeout, aplikasi tidak boleh freeze.
    // Kita cetak error-nya dan tetap jalankan aplikasi agar Splash/Login muncul.
    print("❌ GAGAL MASUK FIREBASE: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AturAja',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const App(),
        '/history': (context) => const HistoryScreen(),
        '/budgeting': (context) => const BudgetingScreen(),
        '/budgeting-new': (context) => const BudgetingNewScreen(),
        '/topup': (context) => const TopUpScreen(),
        '/verify-otp': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as String? ?? '';

          return VerifyIdentityScreen(
            phoneNumber: args,
            onVerifySuccess: () {
              Navigator.pushReplacementNamed(context, '/scan-ktp');
            },
            onBack: () {
              Navigator.pop(context);
            },
          );
        },
        '/scan-ktp': (context) => KtpScannerScreen(
          // 1. Ubah dari fungsi kosong () menjadi menerima parameter string path foto
          onScanSuccess: (String capturedPath) {
            Navigator.pushReplacementNamed(
              context,
              '/confirm-ktp',
              // 2. Kirim path gambar ke rute berikutnya melalui properti arguments
              arguments: capturedPath,
            );
          },
        ),
        '/confirm-ktp': (context) {
          // 3. Tangkap kiriman path gambar dari halaman kamera sebelumnya
          final capturedImagePath =
              ModalRoute.of(context)?.settings.arguments as String? ?? '';

          return ConfirmKtpScreen(
            imagePath: capturedImagePath,
            onConfirm: () {
              // 4. Jika OK, arahkan masuk ke Dashboard Home AturAja
              Navigator.pushReplacementNamed(context, '/scan-face');
            },
            onRetake: () {
              // 5. Jika klik Foto Ulang, kembalikan ke layar kamera
              Navigator.pushReplacementNamed(context, '/scan-ktp');
            },
          );
        },

        '/scan-face': (context) => FaceScannerScreen(
          onScanSuccess: (String capturedSelfiePath) {
            Navigator.pushReplacementNamed(
              context,
              '/confirm-face',
              arguments: capturedSelfiePath, // Lempar path foto Selfie
            );
          },
        ),
        '/confirm-face': (context) {
          final String selfiePath = ModalRoute.of(context)?.settings.arguments as String? ?? '';

          return ConfirmSelfieScreen(
            imagePath: selfiePath,
            onConfirm: () {
              Navigator.pushReplacementNamed(context, '/data-personal'); // Alur sukses tamat, masuk home
            },
            onRetake: () {
              Navigator.pushReplacementNamed(context, '/scan-face'); // Mengulang foto selfie kembali
            },
          );
        },
        '/data-personal': (context) => DataPersonalScreen(
        onComplete: () {
          // Jika data personal selesai diisi, arahkan ke Home
          Navigator.pushReplacementNamed(context, '/home');
        },
      ),
      }
    );
    }
  }
