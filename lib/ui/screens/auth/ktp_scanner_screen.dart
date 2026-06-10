import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aturaja/data/models/registration_data_model.dart';

class KtpScannerScreen extends StatefulWidget {
  const KtpScannerScreen({super.key});

  @override
  State<KtpScannerScreen> createState() => _KtpScannerScreenState();
}

class _KtpScannerScreenState extends State<KtpScannerScreen> {
  late RegistrationDataModel _registrationModel;
  bool _modelLoaded = false;

  File? _ktpImage;
  final ImagePicker _picker = ImagePicker();

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

  // Fungsi untuk membuka kamera HP
  Future<void> _takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
        maxWidth: 800, // Kompresi agar upload ke Firebase lebih cepat
        preferredCameraDevice: CameraDevice.rear, // Gunakan kamera belakang
      );

      if (photo != null) {
        setState(() {
          _ktpImage = File(photo.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuka kamera: $e')));
    }
  }

  // Fungsi untuk melanjutkan ke Face Scanner
  void _handleNext() {
    if (_ktpImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap ambil foto KTP terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update model dengan path gambar KTP
    final updatedModel = _registrationModel.copyWith(
      ktpImagePath: _ktpImage!.path,
    );

    // Lempar data ke Face Scanner (Selfie)
    Navigator.pushNamed(context, '/scan-face', arguments: updatedModel);
  }

  @override
  Widget build(BuildContext context) {
    if (!_modelLoaded) {
      return const Scaffold(body: Center(child: Text('Data tidak valid')));
    }

    final Color brandRed = const Color(0xFFD40300);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Scan KTP'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Foto e-KTP Anda',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Pastikan foto KTP terlihat jelas, tidak terpotong, dan tidak terkena pantulan cahaya.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
              const SizedBox(height: 32),

              // Area Kotak Preview KTP
              Expanded(
                child: GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _ktpImage == null
                            ? Colors.grey.shade400
                            : brandRed,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: _ktpImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(_ktpImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Ketuk untuk memfoto KTP',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Lanjut
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleNext,
                  child: const Text(
                    'Lanjut ke Scan Wajah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
