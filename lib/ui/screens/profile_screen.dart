import 'dart:convert'; // Wajib untuk mendekode Base64 menjadi Gambar
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Pastikan path import ini sesuai dengan lokasi folder user_model.dart Anda!
import 'package:aturaja/data/models/user_model.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color brandRed = const Color(0xFFD31111);
  
  // Mesin Pendorong Database Firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===================================================================
  // FUNGSI INTI: MENGAMBIL DATA DARI FIRESTORE MENGGUNAKAN USER MODEL
  // ===================================================================
  Future<UserModel> _fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedPhone = prefs.getString('user_phone');

      if (storedPhone == null || storedPhone.isEmpty) {
        throw Exception('Nomor HP pengguna tidak ditemukan di memori lokal. Silakan login kembali.');
      }

      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(storedPhone).get();

      if (!userDoc.exists || userDoc.data() == null) {
        throw Exception('Data profil pengguna tidak ditemukan untuk nomor $storedPhone.');
      }

      final Map<String, dynamic> rawData = Map<String, dynamic>.from(userDoc.data() as Map<String, dynamic>);
      rawData['phone_number'] = rawData['phone_number'] ?? rawData['phone'] ?? storedPhone;
      rawData['id'] = rawData['id'] ?? storedPhone;
      rawData['name'] = rawData['name'] ?? rawData['fullName'] ?? 'Pengguna';
      rawData['password'] = rawData['password'] ?? '';
      rawData['pin'] = rawData['pin'] ?? '';

      return UserModel.fromJson(rawData);
    } catch (e) {
      throw Exception('Gagal mengambil data profil: $e');
    }
  }

  // Fungsi Konfirmasi Logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 10))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                  child: Icon(Icons.warning_amber_rounded, color: brandRed, size: 32),
                ),
                const SizedBox(height: 16),
                const Text('Keluar dari AturAja?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87)),
                const SizedBox(height: 8),
                const Text(
                  'Anda harus memasukkan nomor telepon dan PIN kembali untuk masuk ke aplikasi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandRed,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('user_phone');
                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                          }
                        },
                        child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black87, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_balance_wallet, color: brandRed),
            const SizedBox(width: 8),
            Text('Profil AturAja', style: TextStyle(color: brandRed, fontWeight: FontWeight.w900, fontSize: 18)),
          ],
        ),
      ),
      // MENGGUNAKAN FUTURE BUILDER DENGAN USER MODEL
      body: FutureBuilder<UserModel>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: brandRed));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan:\n${snapshot.error}', textAlign: TextAlign.center));
          }

          // Data sudah mendarat dengan aman ke dalam wujud UserModel!
          final UserModel userData = snapshot.data!;
          
          // Mengubah status KYC server menjadi teks cantik
          final String displayStatus = userData.kycStatus == 'pending_verification' 
              ? 'Menunggu Verifikasi' 
              : 'Terverifikasi Akun Gold';

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. PREMIUM ID CARD (Black Gradient)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF09090B), Color(0xFF18181B), Color(0xFF27272A)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // ==========================================================
                          // THE MAGIC HACK: MERENDER TEKS BASE64 MENJADI FOTO PROFIL!
                          // ==========================================================
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: brandRed.withOpacity(0.8), width: 2),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: (userData.selfieImageUrl != null && userData.selfieImageUrl!.isNotEmpty)
                                ? (userData.selfieImageUrl!.startsWith('http')
                                    ? Image.network(
                                        userData.selfieImageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white),
                                      )
                                    : Image.memory(
                                        base64Decode(userData.selfieImageUrl!), // Konversi string jadi gambar
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white),
                                      ))
                                : const Icon(Icons.person, color: Colors.white, size: 40),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Identitas Pemilik', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(
                                  userData.fullName ?? userData.name,
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: brandRed.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: brandRed.withOpacity(0.5)),
                                  ),
                                  child: Text(
                                    displayStatus.toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('ID ATURAJA', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('AA-8819-2101', style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('NOMOR SERI KTP', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                'KTP-${(userData.nik ?? '0000').length > 4 ? userData.nik!.substring(0, 4) : '0000'}****', 
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. DATA TERVERIFIKASI PANEL
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('DATA TERVERIFIKASI KTP', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w900)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade100)),
                            child: Text('PADAN SIP', style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.w900)),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(Icons.person, 'Nama Sesuai KTP', userData.fullName ?? userData.name),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.credit_card, 'NIK Terdaftar', userData.nik ?? 'Tidak diketahui'),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.location_on, 'Alamat Domisili', userData.alamat ?? 'Tidak diketahui'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. PENGATURAN & KEAMANAN
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('PENGATURAN & KEAMANAN', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
                  ),
                  child: Column(
                    children: [
                      _buildSettingsTile(Icons.phone, 'Nomor Handphone', userData.phoneNumber, true),
                      const Divider(height: 1, indent: 64, color: Color(0xFFF0F0F0)),
                      _buildSettingsTile(Icons.lock, 'Ubah PIN Keamanan', 'Terakhir diubah 2 bulan lalu', true),
                      const Divider(height: 1, indent: 64, color: Color(0xFFF0F0F0)),
                      _buildSettingsTile(Icons.notifications, 'Notifikasi Transaksi', 'Email & Push Aktif', false),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 4. TOMBOL LOGOUT
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: brandRed.withOpacity(0.05),
                      side: BorderSide(color: brandRed.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _showLogoutDialog,
                    icon: Icon(Icons.logout, color: brandRed, size: 20),
                    label: Text('Keluar dari Akun', style: TextStyle(color: brandRed, fontWeight: FontWeight.w900, fontSize: 14)),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.grey.shade600, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w900)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, bool showArrow) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: brandRed, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black87)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
      trailing: showArrow 
          ? const Icon(Icons.chevron_right, color: Colors.grey)
          : Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
      onTap: () {},
    );
  }
}