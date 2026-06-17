import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'home/home_screen.dart';
import 'history/history_screen.dart';
import 'notification/notification_screen.dart';
import 'profile_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  // List untuk menampung riwayat teks notifikasi
  List<String> _notifications = [];

  // Status untuk titik merah (belum dibaca)
  bool _hasUnreadNotification = false;

  // Fungsi memicu notifikasi
  void triggerNotification(String pesan) {
    setState(() {
      _notifications.insert(0, pesan);
      _hasUnreadNotification = true;
    });
  }

  // Daftar halaman utama aplikasi
  List<Widget> get _pages => [
    HomeScreen(onBalanceUpdated: triggerNotification),
    HistoryScreen(
      onBack: () {
        setState(() {
          _selectedIndex = 0;
        });
      },
    ),
    NotificationScreen(
      notifications: _notifications,
      onClear: () {
        setState(() {
          _notifications.clear();
          _hasUnreadNotification = false;
        });
      },
    ),
    const SizedBox(), // Placeholder kosong karena profil dipanggil via rute baru
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: _pages),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          // TODO: Implementasi Scan QRIS
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.white, size: 24),
            Text(
              "QRIS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 65,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_rounded, "Home", 0),
            _buildNavItem(Icons.history_rounded, "History", 1),
            const SizedBox(width: 40),
            _buildNavItem(
              Icons.mail_outline_rounded,
              "Notifications",
              2,
              isNotif: _hasUnreadNotification,
            ),
            _buildNavItem(Icons.person_outline_rounded, "Profile", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {bool isNotif = false}) {
    // Profil tidak menggunakan index state, jadi kita atur isActive-nya false saat di menu lain
    bool isActive = _selectedIndex == index && index != 3;

    return InkWell(
      onTap: () {
        // JIKA YANG DIKLIK ADALAH PROFIL (INDEX 3)
        if (index == 3) {
          // Tembak langsung ke halaman ProfileScreen!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
          return;
        }

        // Jika yang diklik menu lain
        setState(() {
          _selectedIndex = index;
          if (index == 2) {
            _hasUnreadNotification = false; // Matikan titik merah saat buka notifikasi
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: isActive ? AppColors.brandRed : Colors.grey.shade400,
                ),
                if (isNotif)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.brandRed : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}