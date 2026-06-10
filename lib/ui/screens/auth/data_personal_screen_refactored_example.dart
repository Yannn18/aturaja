import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aturaja/data/models/registration_data_model.dart';

/// ===================================================================
/// STRUCTURAL EXAMPLE: DataPersonalScreen with RegistrationDataModel
/// ===================================================================
///
/// This example demonstrates the recommended pattern for:
/// 1. Extracting RegistrationDataModel from navigation arguments
/// 2. Updating the model with new personal data
/// 3. Passing the updated model forward to the next screen (KtpScannerScreen)

class DataPersonalScreenRefactored extends StatefulWidget {
  const DataPersonalScreenRefactored({Key? key}) : super(key: key);

  @override
  State<DataPersonalScreenRefactored> createState() =>
      _DataPersonalScreenRefactoredState();
}

class _DataPersonalScreenRefactoredState
    extends State<DataPersonalScreenRefactored> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _nikController = TextEditingController();
  final _alamatController = TextEditingController();

  // Model yang diekstrak dari arguments
  late RegistrationDataModel _registrationModel;
  bool _modelLoaded = false;
  String? _loadError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Extract RegistrationDataModel dari navigation arguments (hanya sekali)
    if (!_modelLoaded) {
      try {
        final args = ModalRoute.of(context)?.settings.arguments;

        if (args == null) {
          _loadError = 'Registration data not found. Please start from SignUp.';
          _modelLoaded = true;
          return;
        }

        // Cast argument ke RegistrationDataModel
        if (args is RegistrationDataModel) {
          _registrationModel = args;
          _modelLoaded = true;
          print('✓ RegistrationDataModel loaded: ${_registrationModel.phone}');
        } else {
          _loadError =
              'Invalid argument type. Expected RegistrationDataModel, got ${args.runtimeType}';
          _modelLoaded = true;
        }
      } catch (e) {
        _loadError = 'Error loading registration data: ${e.toString()}';
        _modelLoaded = true;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _nikController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  /// Handle submit: Update model dengan personal data dan navigasi ke KTP Scanner
  void _handleSubmit() {
    // Validasi form terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Step 1: Update RegistrationDataModel dengan data dari form personal
      final updatedModel = _registrationModel.copyWith(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        // Note: ktpImagePath dan selfieImagePath masih kosong,
        // akan diisi di KtpScannerScreen dan FaceScannerScreen
      );

      print('✓ Model updated with personal data:');
      print('  - Full Name: ${updatedModel.fullName}');
      print('  - Email: ${updatedModel.email}');
      print('  - Phone: ${updatedModel.phone}');

      // Step 2: Navigasi ke KTP Scanner screen dengan model yang sudah diupdate
      Navigator.pushNamed(
        context,
        '/ktp-scanner',
        arguments: updatedModel, // Pass updated model ke screen berikutnya
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Error state: model tidak berhasil dimuat
    if (!_modelLoaded || _loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Data Personal')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _loadError ?? 'Loading registration data...',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }

    // Loading state
    if (!_modelLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Data Personal')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Main form
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      appBar: AppBar(
        title: const Text('Data Personal'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display current phone dari model (read-only)
              _buildReadOnlyField(
                label: 'Nomor Handphone (dari SignUp)',
                value: _registrationModel.phone,
              ),
              const SizedBox(height: 24),

              // Full Name input
              _buildInputField(
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap Anda',
                controller: _fullNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama lengkap tidak boleh kosong';
                  }
                  if (value.length < 3) {
                    return 'Nama harus minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Email input
              _buildInputField(
                label: 'Email',
                hint: 'Masukkan email Anda',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // NIK input
              _buildInputField(
                label: 'NIK (No. Identitas Kependudukan)',
                hint: '16 digit NIK',
                controller: _nikController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIK tidak boleh kosong';
                  }
                  if (value.length != 16) {
                    return 'NIK harus 16 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Alamat input
              _buildInputField(
                label: 'Alamat Lengkap',
                hint: 'Masukkan alamat lengkap Anda',
                controller: _alamatController,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 48),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD40300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lanjut ke KTP Scanner',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  /// Helper widget untuk input field biasa
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD40300), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper widget untuk display field read-only (dari previous screen)
  Widget _buildReadOnlyField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
