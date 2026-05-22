import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class KtpScannerScreen extends StatefulWidget {
  final Function(String) onScanSuccess;
  final VoidCallback onBack;

  const KtpScannerScreen({
    Key? key,
    required this.onScanSuccess,
    required this.onBack,
  }) : super(key: key);

  @override
  State<KtpScannerScreen> createState() => _KtpScannerScreenState();
}

class _KtpScannerScreenState extends State<KtpScannerScreen> with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  bool _isPermissionGranted = false;
  bool _isCapturing = false;
  bool _showSuccess = false;
  bool _flashEffect = false;

  final ImagePicker _picker = ImagePicker();
  late AnimationController _laserController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    // Mengatur animasi turun-naik laser merah saat kamera belum aktif/simulasi
    _laserController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _initCameraController(_cameras![_selectedCameraIndex]);
      }
    } catch (e) {
      debugPrint('Error mendeteksi kamera: $e');
    }
  }

  Future<void> _initCameraController(CameraDescription cameraDescription) async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isPermissionGranted = true;
        });
      }
    } catch (e) {
      debugPrint('Error inisialisasi kontroler kamera: $e');
      if (mounted) {
        setState(() {
          _isPermissionGranted = false;
        });
      }
    }
  }

  void _handleFlipCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    setState(() {
      _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    });
    _initCameraController(_cameras![_selectedCameraIndex]);
  }

Future<void> _handleGalleryAccess() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Masukkan path dari galeri ke dalam fungsi simulasi
      _triggerScanSimulation(image.path);
    }
  }

  Future<void> _handleCapture() async {
    if (_isCapturing || _showSuccess) return;

    // 1. Jalankan Efek Flash Putih Layar
    setState(() {
      _flashEffect = true;
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _flashEffect = false);
    });

    String capturedPath = "";

    // 2. Ambil Foto Asli jika kamera menyala
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile fileFoto = await _cameraController!.takePicture();
        capturedPath = fileFoto.path; // Ambil path hasil foto kamera
      } catch (e) {
        debugPrint("Gagal mengambil gambar fisik: $e");
      }
    }

    // Jalankan simulasi dengan membawa path gambar (dari kamera atau fallback kosong jika gagal)
    _triggerScanSimulation(capturedPath);
  }

  // 3. PASTIKAN Fungsi Jalur Simulasi Anda Diubah Juga Agar Menerima Parameter String:
  void _triggerScanSimulation(String path) {
    setState(() {
      _isCapturing = true;
    });

    // Simulasi pemindaian OCR selama 1.2 detik
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isCapturing = false;
        _showSuccess = true;
      });

      // Pindah halaman setelah animasi sukses selesai
      Future.delayed(const Duration(milliseconds: 1600), () {
        if (mounted) {
          // Kirim variabel path asli keluar menuju app.dart!
          widget.onScanSuccess(path);
        }
      });
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _laserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Stack(
        children: [
          // -------------------------------------------------------------------
          // VIEWPORT KAMERA UTAMA / FALLBACK SIMULASI MOCK
          // -------------------------------------------------------------------
          Positioned.fill(
            child: _isPermissionGranted && _cameraController != null
                ? CameraPreview(_cameraController!)
                : _buildMockScannerFallback(screenWidth),
          ),

          // -------------------------------------------------------------------
          // OVERLAY MASK HITAM TRANSLUSEN (BINGKAI KTP)
          // -------------------------------------------------------------------
          Positioned.fill(
            child: Column(
              children: [
                // Top Overlay Mask
                Container(
                  height: MediaQuery.of(context).size.height * 0.26,
                  color: Colors.black.withOpacity(0.6),
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Posisikan KTP Anda di dalam bingkai",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Pastikan kartu terlihat jelas dengan pencahayaan yang cukup.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Color(0xFFD1D5DB), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                
                // Middle Overlay Mask (Framing Bingkai Target)
                Row(
                  children: [
                    Container(width: screenWidth * 0.08, height: 210, color: Colors.black.withOpacity(0.6)),
                    Expanded(
                      child: Container(
                        height: 210,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Custom L-Shaped Corners (Thick Borders)
                            Positioned(top: -4, left: -4, child: Container(width: 32, height: 32, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white, width: 5), left: BorderSide(color: Colors.white, width: 5)), borderRadius: BorderRadius.only(topLeft: Radius.circular(24))))),
                            Positioned(top: -4, right: -4, child: Container(width: 32, height: 32, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white, width: 5), right: BorderSide(color: Colors.white, width: 5)), borderRadius: BorderRadius.only(topRight: Radius.circular(24))))),
                            Positioned(bottom: -4, left: -4, child: Container(width: 32, height: 32, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white, width: 5), left: BorderSide(color: Colors.white, width: 5)), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24))))),
                            Positioned(bottom: -4, right: -4, child: Container(width: 32, height: 32, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white, width: 5), right: BorderSide(color: Colors.white, width: 5)), borderRadius: BorderRadius.only(bottomRight: Radius.circular(24))))),
                            
                            // Loader Menganalisis Spinner
                            if (_isCapturing)
                              Container(
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(24)),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD31111)), strokeWidth: 4),
                                      SizedBox(height: 12),
                                      Text("MENGANALISIS KTP...", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(width: screenWidth * 0.08, height: 210, color: Colors.black.withOpacity(0.6)),
                  ],
                ),

                // Bottom Overlay Mask
                Expanded(
                  child: Container(color: Colors.black.withOpacity(0.6)),
                ),
              ],
            ),
          ),

          // -------------------------------------------------------------------
          // ANIMASI SAKSES INTEGRAL (FULL SCREEN OVERLAY INSIDE FRAME)
          // -------------------------------------------------------------------
          if (_showSuccess)
            Positioned(
              left: screenWidth * 0.08,
              right: screenWidth * 0.08,
              top: MediaQuery.of(context).size.height * 0.26,
              height: 210,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: Color(0xFF34D399), size: 56),
                    SizedBox(height: 10),
                    Text("KTP BERHASIL DIPINDAI", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFA7F3D0), letterSpacing: 1)),
                    SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Identitas terverifikasi aman melalui jaringan enkripsi AturAja", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFF6EE7B7), height: 1.4)),
                    ),
                  ],
                ),
              ),
            ),

          // -------------------------------------------------------------------
          // FLOATING BACK BUTTON (TOP LEFT)
          // -------------------------------------------------------------------
          Positioned(
            top: 20,
            left: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.1))),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // CONTROLLER INTERACTION PANEL (BOTTOM BAR)
          // -------------------------------------------------------------------
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // BUTTON 1: GALLERY ACCESS
                  _buildControlItem("GALLERY", GestureDetector(
                    onTap: _handleGalleryAccess,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.4), width: 2), color: Colors.black.withOpacity(0.4)),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: const BoxDecoration(color: Color(0xFF262626), shape: BoxShape.circle),
                        child: const Icon(Icons.image_outlined, color: Colors.white, size: 20),
                      ),
                    ),
                  )),

                  // BUTTON 2: MAIN SHUTTER TRIGGER
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.2), width: 4)),
                    child: Center(
                      child: GestureDetector(
                        onTap: _handleCapture,
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Center(
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(color: const Color(0xFFD31111).withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD31111).withOpacity(0.2))),
                              child: Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFD31111), shape: BoxShape.circle))),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // BUTTON 3: FLIP CAMERA OVER
                  _buildControlItem("FLIP", GestureDetector(
                    onTap: _handleFlipCamera,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.2))),
                      child: const Icon(Icons.refresh, color: Colors.white, size: 22),
                    ),
                  )),
                ],
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // SCREEN CAMERA FLASH EFFECT SHIELD
          // -------------------------------------------------------------------
          if (_flashEffect)
            Positioned.fill(child: Container(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildControlItem(String label, Widget button) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD1D5DB), letterSpacing: 1)),
      ],
    );
  }

  // Desain KTP Scanner Mock Fallback Persis Seperti Framework React Anda
  Widget _buildMockScannerFallback(double width) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF343434), Color(0xFF1F1F1F), Color(0xFF121212)]),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radar Lines Animating
          AnimatedBuilder(
            animation: _laserController,
            builder: (context, child) {
              return Positioned(
                top: (MediaQuery.of(context).size.height * 0.26) + 12 + (_laserController.value * 180),
                child: Container(
                  width: width * 0.75,
                  height: 3,
                  decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.6), blurRadius: 15, spreadRadius: 2)]),
                ),
              );
            },
          ),
          
          // KTP Shape Mock Card Inside Frame
          Container(
            width: width * 0.75,
            height: 160,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF0369A1).withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.2))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFF38BDF8).withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.badge_outlined, color: Color(0xFF38BDF8), size: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Container(height: 10, width: 120, decoration: BoxDecoration(color: const Color(0xFF38BDF8).withOpacity(0.3), borderRadius: BorderRadius.circular(4))),
                          const SizedBox(height: 6),
                          Container(height: 8, width: 80, decoration: BoxDecoration(color: const Color(0xFF38BDF8).withOpacity(0.2), borderRadius: BorderRadius.circular(4))),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("REPUBLIK INDONESIA", style: TextStyle(fontSize: 7, color: Color(0xFF0284C7), fontFamily: 'monospace', letterSpacing: 1)),
                    Container(width: 20, height: 24, decoration: BoxDecoration(color: const Color(0xFFFACC15).withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}