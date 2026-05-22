class SlideData {
  final String titleStart;
  final String titleHighlight;
  final String description;

  SlideData({
    required this.titleStart,
    required this.titleHighlight,
    required this.description,
  });
}

final List<SlideData> onboardingSlides = [
  SlideData(
    titleStart: "Atur Anggaran dalam\n",
    titleHighlight: "Sekejap.",
    description: "Gunakan fitur Smart Budgeting untuk menyusun rencana keuangan secara otomatis. Kelola pengeluaranmu lebih praktis dengan bantuan rekomendasi cerdas yang sesuai dengan kebutuhanmu.",
  ),
  SlideData(
    titleStart: "Privasi Anda,\n",
    titleHighlight: "Kendali Anda.",
    description: "Data Anda terenkripsi 100% secara end-to-end. Pantau dan kelola penggunaan data Anda secara transparan melalui Privacy Dashboard kami.",
  ),
  SlideData(
    titleStart: "Dana Aman di\n",
    titleHighlight: "Setiap Kantong.",
    description: "Kelola anggaran lebih fleksibel dengan sistem sub-wallet yang dilindungi keamanan biometrik dan enkripsi transaksi berlapis.",
  ),
];