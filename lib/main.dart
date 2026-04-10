import 'package:aturaja/ui/screens/app.dart';
import 'package:aturaja/ui/screens/history/history_screen.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AturAja',
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const App(),
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}
