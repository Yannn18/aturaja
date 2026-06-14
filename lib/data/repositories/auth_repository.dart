import 'dart:io';
import 'dart:convert'; // <--- Tambahan untuk meretas gambar menjadi Teks

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/registration_data_model.dart';

class RegistrationException implements Exception {
  final String message;
  final String? code;
  final Exception? originalException;

  RegistrationException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() =>
      'RegistrationException: $message${code != null ? ' (Code: $code)' : ''}';
}

class AuthRepository {
  // KITA HAPUS FIREBASE STORAGE. HANYA GUNAKAN FIRESTORE!
  final FirebaseFirestore _firebaseFirestore;
  static const String _usersCollection = 'users';

  AuthRepository({FirebaseFirestore? firebaseFirestore})
    : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<String> registerCompleteUser(RegistrationDataModel data) async {
    try {
      _validateRegistrationData(data);

      print('⚡ Mengkonversi Foto Fisik menjadi Teks Base64...');

      // 1. UBAH FOTO KTP MENJADI TEKS (BASE64 HACK)
      String ktpBase64 = '';
      if (data.ktpImagePath.isNotEmpty &&
          File(data.ktpImagePath).existsSync()) {
        final bytes = await File(data.ktpImagePath).readAsBytes();
        ktpBase64 = base64Encode(
          bytes,
        ); // Gambar diringkas menjadi teks panjang
      }

      // 2. UBAH FOTO SELFIE MENJADI TEKS (BASE64 HACK)
      String selfieBase64 = '';
      if (data.selfieImagePath.isNotEmpty &&
          File(data.selfieImagePath).existsSync()) {
        final bytes = await File(data.selfieImagePath).readAsBytes();
        selfieBase64 = base64Encode(bytes);
      }

      // 3. KEMAS SEMUANYA KE DALAM SATU DOKUMEN FIRESTORE
      final Map<String, dynamic> userProfile = {
        'phone': data.phone,
        'password': data.password,
        'fullName': data.fullName,
        'email': data.email,
        'nik': data.nik,
        'alamat': data.alamat,
        // Menyimpan teks gambar pengganti URL Storage
        'ktpImageUrl': ktpBase64,
        'selfieImageUrl': selfieBase64,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'kycStatus': 'pending_verification',
        'isEmailVerified': false,
        'isPhoneVerified': false,
      };

      print('⚡ Menembakkan Data dan Gambar ke Cloud Firestore...');

      // 4. SIMPAN KE FIRESTORE (Database yang sudah aktif tanpa kartu kredit)
      final DocumentReference userDoc = _firebaseFirestore
          .collection(_usersCollection)
          .doc(data.phone);

      await userDoc.set(userProfile, SetOptions(merge: false));
      print('✓ DATA REKOR USER BERHASIL DISIMPAN!');

      return data.phone;
    } catch (e) {
      throw RegistrationException(
        message: 'Unexpected error during registration: ${e.toString()}',
      );
    }
  }

  void _validateRegistrationData(RegistrationDataModel data) {
    if (data.phone.isEmpty)
      throw RegistrationException(message: 'Phone number required');
    if (data.fullName.isEmpty)
      throw RegistrationException(message: 'Name required');
    if (data.nik.isEmpty) throw RegistrationException(message: 'NIK required');
    if (data.alamat.isEmpty)
      throw RegistrationException(message: 'Address required');
    if (!File(data.ktpImagePath).existsSync())
      throw RegistrationException(message: 'KTP file not found');
    if (!File(data.selfieImagePath).existsSync())
      throw RegistrationException(message: 'Selfie file not found');
  }
}
