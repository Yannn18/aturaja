import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aturaja/data/models/registration_data_model.dart'; // Sesuaikan path

class ConfirmSelfieScreen extends StatefulWidget {
  const ConfirmSelfieScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmSelfieScreen> createState() => _ConfirmSelfieScreenState();
}

class _ConfirmSelfieScreenState extends State<ConfirmSelfieScreen> {
  late RegistrationDataModel _registrationModel;
  bool _modelLoaded = false;
  String _imagePath = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_modelLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RegistrationDataModel) {
        _registrationModel = args;
        _imagePath = _registrationModel.selfieImagePath;
        _modelLoaded = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_modelLoaded) {
      return const Scaffold(
        body: Center(child: Text("Data registrasi gagal dimuat.")),
      );
    }

    final bool hasValidImage =
        _imagePath.isNotEmpty && File(_imagePath).existsSync();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          "Apakah Selfie Sudah Jelas?",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0A0A0A),
                            letterSpacing: -0.5,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Pastikan seluruh wajah terlihat jelas tanpa bayangan\natau penghalang untuk keamanan akun Anda.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 360,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFFF1F2,
                                  ).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: const Color(0xFFFECDD3),
                                    width: 2.5,
                                  ),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: AspectRatio(
                                  aspectRatio: 1.35,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      color: const Color(0xFFF5F5F5),
                                      child: hasValidImage
                                          ? Image.file(
                                              File(_imagePath),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                            )
                                          : _buildVectorFallbackMesh(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFF5F5F5)),
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Color(0xFFFFF1F2),
                                child: Icon(
                                  Icons.visibility_outlined,
                                  color: Color(0xFFD31111),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Apakah foto sudah jelas?",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF171717),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "Data harus terbaca tanpa buram atau silau.",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: const Color(0xFFE5E5E5).withOpacity(0.5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "TIPS KUALITAS FOTO",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTipRow("Pencahayaan cukup dan merata"),
                              const SizedBox(height: 12),
                              _buildTipRow(
                                "Wajah tidak terpotong (masuk dalam frame)",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(
                                    context,
                                  ), // Mengulang foto selfie kembali
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Color(0xFFE5E5E5),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.refresh_rounded,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Foto Ulang",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF424242),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Bawa koper data lanjut ke form final Data Personal
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/data-personal',
                                      arguments: _registrationModel,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD31111),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    elevation: 3,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_rounded, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        "Gunakan Foto",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTipRow(String tipText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFF1F2).withOpacity(0.2),
            border: Border.all(color: const Color(0xFFFECDD3)),
          ),
          child: const Center(
            child: Icon(Icons.check, size: 10, color: Color(0xFFD31111)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            tipText,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF404040),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVectorFallbackMesh() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFAF4F0), Color(0xFFE2D4C9), Color(0xFF8C7A6B)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.account_box_rounded,
          size: 80,
          color: const Color(0xFF1A1A1A).withOpacity(0.6),
        ),
      ),
    );
  }
}
