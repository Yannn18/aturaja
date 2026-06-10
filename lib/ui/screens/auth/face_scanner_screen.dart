import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:aturaja/data/models/registration_data_model.dart'; // Sesuaikan path

class FaceScannerScreen extends StatefulWidget {
  const FaceScannerScreen({Key? key}) : super(key: key);

  @override
  State<FaceScannerScreen> createState() => _FaceScannerScreenState();
}

class _FaceScannerScreenState extends State<FaceScannerScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isCapturing = false;
  bool _showSuccess = false;
  bool _flashEffect = false;
  int _selectedCameraIndex = 1;

  late RegistrationDataModel _registrationModel;
  bool _modelLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_modelLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RegistrationDataModel) {
        _registrationModel = args;
        _modelLoaded = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        int frontCamIndex = _cameras!.indexWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
        );
        _selectedCameraIndex = frontCamIndex != -1 ? frontCamIndex : 0;
        await _setupController();
      }
    } catch (e) {
      debugPrint("Gagal menginisialisasi kamera: $e");
    }
  }

  Future<void> _setupController() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }
    _cameraController = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await _cameraController!.initialize();
      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint("Gagal membuka modul kamera: $e");
    }
  }

  void _handleFlipCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    setState(() {
      _isInitialized = false;
      _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    });
    _setupController();
  }

  void _handleCapture() async {
    if (_isCapturing || _showSuccess || !_modelLoaded) return;

    setState(() => _flashEffect = true);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _flashEffect = false);
    });

    setState(() => _isCapturing = true);
    String capturedPath = "";

    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile fileFoto = await _cameraController!.takePicture();
        capturedPath = fileFoto.path;
      } catch (e) {
        debugPrint("Gagal menjepret gambar biometrik: $e");
      }
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isCapturing = false;
        _showSuccess = true;
      });

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          // Masukkan path selfie ke koper data
          final updatedModel = _registrationModel.copyWith(
            selfieImagePath: capturedPath,
          );

          // Lempar ke halaman confirm selfie
          Navigator.pushReplacementNamed(
            context,
            '/confirm-face',
            arguments: updatedModel,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: Stack(
        children: [
          if (_isInitialized && _cameraController != null)
            Positioned.fill(
              child: Transform.scale(
                scale:
                    1 /
                    (_cameraController!.value.aspectRatio *
                        MediaQuery.of(context).size.aspectRatio),
                alignment: Alignment.center,
                child: Transform(
                  alignment: Alignment.center,
                  transform:
                      _cameras![_selectedCameraIndex].lensDirection ==
                          CameraLensDirection.front
                      ? Matrix4.rotationY(3.14159)
                      : Matrix4.identity(),
                  child: CameraPreview(_cameraController!),
                ),
              ),
            )
          else
            Positioned.fill(child: Container(color: const Color(0xFF111111))),

          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.65),
                BlendMode.srcOut,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD31111),
                        width: 4.5,
                      ),
                    ),
                  ),
                  if (_isCapturing) _buildLoadingOverlay(),
                  if (_showSuccess) _buildSuccessOverlay(),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 36.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 340),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF212121).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Posisikan wajah Anda di dalam lingkaran",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Pastikan cahaya cukup terang agar verifikasi lancar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 25,
                        offset: Offset(0, -8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(
                    top: 28,
                    bottom: 24,
                    left: 32,
                    right: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 56, height: 56),
                          Container(
                            width: 74,
                            height: 74,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFD31111).withOpacity(0.2),
                                width: 4,
                              ),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: (_isCapturing || _showSuccess)
                                    ? null
                                    : _handleCapture,
                                child: Container(
                                  width: 58,
                                  height: 58,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: (_isCapturing || _showSuccess)
                                            ? Colors.grey.withOpacity(0.1)
                                            : const Color(
                                                0xFFD31111,
                                              ).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: (_isCapturing || _showSuccess)
                                              ? Colors.grey.withOpacity(0.2)
                                              : const Color(
                                                  0xFFD31111,
                                                ).withOpacity(0.2),
                                        ),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color:
                                                (_isCapturing || _showSuccess)
                                                ? Colors.grey
                                                : const Color(0xFFD31111),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _buildControlItem(
                            "FLIP",
                            GestureDetector(
                              onTap: _handleFlipCamera,
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.refresh,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF9F9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              color: Color(0xFFD31111),
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "KEAMANAN TERJAMIN",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFBA1212),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B7280),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD31111)),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "ANALISIS BIOMETRIK...",
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: Color(0xFFD31111),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF064E3B).withOpacity(0.85),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Color(0xFF34D399),
            ),
            SizedBox(height: 6),
            Text(
              "PEMINDAIAN SELESAI",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Color(0xFFA7F3D0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  