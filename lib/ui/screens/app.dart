import 'package:flutter/material.dart';
import '../../core/constants/colors.dart'; // Import konstanta warna
import 'home/home_screen.dart';
import 'history/history_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  // Daftar halaman utama aplikasi
  List<Widget> get _pages => [
        const HomeScreen(),
        HistoryScreen(
          onBack: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
        ),
        const Center(child: Text("Message Page", style: TextStyle(fontSize: 24))),
        const Center(child: Text("Profile Page", style: TextStyle(fontSize: 24))),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // IndexedStack menjaga State (seperti posisi scroll) di tiap halaman
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // Tombol QRIS di tengah (Floating)
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

      // Menentukan posisi FAB agar "masuk" ke dalam BottomAppBar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Navigation Bar dengan Notch (Lengkungan)
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 65,
        color: Colors.white,
        shape: const CircularNotchedRectangle(), // Membuat lengkungan untuk FAB
        notchMargin: 8, // Jarak antara FAB dan lengkungan
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_rounded, "Home", 0),
            _buildNavItem(Icons.history_rounded, "History", 1),
            const SizedBox(width: 40), // Ruang kosong untuk ditempati FAB QRIS
            
            // CONTOH: Menambahkan notifikasi pada menu Message
            _buildNavItem(Icons.mail_outline_rounded, "Message", 2, isNotif: true), 
            
            _buildNavItem(Icons.person_outline_rounded, "Profile", 3),
          ],
        ),
      ),
    );
  }

  // Helper widget dengan tambahan parameter isNotif
  Widget _buildNavItem(IconData icon, String label, int index, {bool isNotif = false}) {
    bool isActive = _selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menerapkan Stack untuk menumpuk Icon dan Badge Notifikasi
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: isActive ? AppColors.brandRed : Colors.grey.shade400,
                ),
                
                // Logika IF untuk menampilkan titik merah notifikasi
                if (isNotif)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red, // Warna titik notifikasi
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5), // Garis tepi putih agar rapi
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