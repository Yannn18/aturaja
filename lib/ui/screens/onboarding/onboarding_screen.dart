import 'package:flutter/material.dart';
import '../../../core/models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _activeTab = 0;

  void _handleNext() {
    if (_activeTab < onboardingSlides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToSignup();
    }
  }

  void _navigateToSignup() {
    // Berpindah ke halaman signup dan menghapus tumpukan screen onboarding
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFFFF1F2).withOpacity(0.1),
              const Color(0xFFFECDD3).withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              children: [
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "AturAja",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD31111),
                        letterSpacing: -0.5,
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToSignup,
                      child: const Text(
                        "Lewati",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                // Dynamic Graphic Visual Block Area (PageView)
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _activeTab = index;
                      });
                    },
                    itemCount: onboardingSlides.length,
                    itemBuilder: (context, index) {
                      return _buildGraphicVisual(index);
                    },
                  ),
                ),

                // Description Content Card Box
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFE4E6).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Indicator dots/pills layout
                      Row(
                        children: List.generate(
                          onboardingSlides.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 6.0),
                            height: 6.0,
                            width: _activeTab == index ? 32.0 : 6.0,
                            decoration: BoxDecoration(
                              color: _activeTab == index
                                  ? const Color(0xFFD31111)
                                  : Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Informational Messaging Text
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            height: 1.2,
                          ),
                          children: [
                            TextSpan(text: onboardingSlides[_activeTab].titleStart),
                            TextSpan(
                              text: onboardingSlides[_activeTab].titleHighlight,
                              style: const TextStyle(color: Color(0xFFD31111)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      
                      Text(
                        onboardingSlides[_activeTab].description,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      
                      // Badge Indicators khusus untuk Halaman Kedua (Privacy)
                      if (_activeTab == 1) ...[
                        const SizedBox(height: 16.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            _buildBadge(Icons.shield_outlined, "Izin Akses"),
                            _buildBadge(Icons.access_time, "Log Aktif"),
                            _buildBadge(Icons.person_outline, "Anonimitas"),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Primary Action Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _handleNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD31111),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _activeTab == onboardingSlides.length - 1
                                ? "Mulai Sekarang"
                                : "Berikutnya",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_activeTab < onboardingSlides.length - 1) ...[
                            const SizedBox(width: 8.0),
                            const Icon(Icons.arrow_forward, size: 20),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFD31111)),
          const SizedBox(width: 6.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphicVisual(int index) {
    // Menyusun grafik kotak / susunan geometris kustom berdasarkan halaman aktif
    if (index == 0) {
      return Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Container(width: 100, height: 100, decoration: BoxDecoration(color: const Color(0xFFF5B5B5).withOpacity(0.6), borderRadius: BorderRadius.circular(16))),
            Container(width: 100, height: 100, decoration: BoxDecoration(color: const Color(0xFFF5B5B5).withOpacity(0.8), borderRadius: BorderRadius.circular(16))),
            Container(width: 100, height: 100, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(16))),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: const Color(0xFFD31111), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]),
              child: const Icon(Icons.trending_up, color: Colors.white, size: 48),
            ),
          ],
        ),
      );
    } else if (index == 1) {
      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD31111).withOpacity(0.2), style: BorderStyle.none))),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(color: const Color(0xFFD31111), borderRadius: BorderRadius.circular(32)),
              child: const Icon(Icons.lock_outline, color: Colors.white, size: 56),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Container(
          width: 160,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 20)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFFD31111), size: 48),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                child: const Text("SUB-WALLET", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.green)),
              )
            ],
          ),
        ),
      );
    }
  }
}