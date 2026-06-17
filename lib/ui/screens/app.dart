import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'home/home_screen.dart';
import 'history/history_screen.dart';
import 'notification/notification_screen.dart'; // Import halaman notifikasi baru

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  // 1. List untuk menampung riwayat teks notifikasi
  List<String> _notifications = [];

  // 2. Status untuk titik merah (belum dibaca)
  bool _hasUnreadNotification = false;

  // 3. Fungsi memicu notifikasi
  void triggerNotification(String pesan) {
    setState(() {
      _notifications.insert(0, pesan); // Teks dinamis masuk ke sini
      _hasUnreadNotification = true; // Nyalakan titik merah
    });
  }

  // 4. Daftar halaman utama aplikasi
  List<Widget> get _pages => [
    // Mengirim fungsi triggerNotification ke HomeScreen
    HomeScreen(onBalanceUpdated: triggerNotification),

    HistoryScreen(
      onBack: () {
        setState(() {
          _selectedIndex = 0;
        });
      },
    ),

    // Notification Screen dimasukkan di sini
    NotificationScreen(
      notifications: _notifications,
      onClear: () {
        setState(() {
          _notifications.clear(); // Hapus semua notifikasi dari daftar
          _hasUnreadNotification = false; // Matikan titik merah
        });
      },
    ),

    const Center(child: Text("Profile Page", style: TextStyle(fontSize: 24))),
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

            // Integrasi Notifikasi di sini:
            _buildNavItem(
                Icons.mail_outline_rounded,
                "Notifications",
                2,
                isNotif: _hasUnreadNotification // Menggunakan variabel status baca
            ),

            _buildNavItem(Icons.person_outline_rounded, "Profile", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {bool isNotif = false}) {
    bool isActive = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          // Jika user klik menu notifikasi, matikan titik merahnya
          if (index == 2) {
            _hasUnreadNotification = false;
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