import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Deklarasi variabel untuk mengontrol animasi (Mirip initial & animate di React)
  double _opacity = 0.0;
  double _scale = 0.5;
  double _rotation = -0.785; // Kurang lebih -45 derajat dalam radian

  @override
  void initState() {
    super.initState();

    // Memicu animasi setelah widget dirender (Mirip useEffect di React)
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
        _rotation = 0.0;
      });
    });

    // Pindah ke halaman Home setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      // Navigasi ke rute home yang sudah didaftarkan di main.dart
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bg-brand-red
      backgroundColor: const Color(0xFFD32F2F),
      body: Center(
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 800),
          curve: Curves
              .easeOutBack, // Memberikan efek "spring" seperti di Framer Motion
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 800),
            child: AnimatedRotation(
              turns: _rotation / (2 * 3.14159), // Konversi radian ke turns
              duration: const Duration(milliseconds: 800),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Placeholder untuk Logo komponen Anda
                  Image.asset(
                    'assets/images/aturajalogo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'AturAja!',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
