import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/registration_data_model.dart';

/// Exception class for registration-related errors
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

/// Repository class handling complete user registration flow
class AuthRepository {
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;

  /// Storage paths for user uploads
  static const String _storageKtpPath = 'users/ktp';
  static const String _storagSelfiePath = 'users/selfie';

  /// Firestore collection name
  static const String _usersCollection = 'users';

  AuthRepository({
    FirebaseStorage? firebaseStorage,
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
       _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  /// Register a complete user with KYC documents and Firebase upload
  ///
  /// This method:
  /// 1. Uploads KTP image to Firebase Storage
  /// 2. Uploads Selfie image to Firebase Storage
  /// 3. Gets download URLs for both images
  /// 4. Saves user profile to Firestore (excluding plain password)
  ///
  /// Throws [RegistrationException] if any step fails
  Future<String> registerCompleteUser(RegistrationDataModel data) async {
    try {
      // Validate input data
      _validateRegistrationData(data);

      // Upload KTP image and get URL
      final String ktpDownloadUrl = await _uploadImage(
        filePath: data.ktpImagePath,
        storagePath: '$_storageKtpPath/${data.phone}_ktp.jpg',
        imageType: 'KTP',
      );

      // Upload Selfie image and get URL
      final String selfieDownloadUrl = await _uploadImage(
        filePath: data.selfieImagePath,
        storagePath: '$_storagSelfiePath/${data.phone}_selfie.jpg',
        imageType: 'Selfie',
      );

      // Prepare user profile data for Firestore (EXCLUDING password)
      final Map<String, dynamic> userProfile = {
        'phone': data.phone,
        'fullName': data.fullName,
        'email': data.email,
        'ktpImageUrl': ktpDownloadUrl,
        'selfieImageUrl': selfieDownloadUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'kyxStatus': 'pending_verification', // KYC status
        'isEmailVerified': false,
        'isPhoneVerified': false,
      };

      // Save user profile to Firestore
      final String userId = await _saveUserProfile(
        phone: data.phone,
        userProfile: userProfile,
      );

      return userId;
    } on RegistrationException {
      rethrow;
    } catch (e, stackTrace) {
      throw RegistrationException(
        message: 'Unexpected error during registration: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Validate registration data before processing
  void _validateRegistrationData(RegistrationDataModel data) {
    if (data.phone.isEmpty) {
      throw RegistrationException(message: 'Phone number is required');
    }
    if (data.password.isEmpty) {
      throw RegistrationException(message: 'Password is required');
    }
    if (data.fullName.isEmpty) {
      throw RegistrationException(message: 'Full name is required');
    }
    if (data.email.isEmpty) {
      throw RegistrationException(message: 'Email is required');
    }
    if (data.ktpImagePath.isEmpty) {
      throw RegistrationException(message: 'KTP image is required');
    }
    if (data.selfieImagePath.isEmpty) {
      throw RegistrationException(message: 'Selfie image is required');
    }

    // Validate file existence
    if (!File(data.ktpImagePath).existsSync()) {
      throw RegistrationException(message: 'KTP image file not found');
    }
    if (!File(data.selfieImagePath).existsSync()) {
      throw RegistrationException(message: 'Selfie image file not found');
    }
  }

  /// Upload image to Firebase Storage and return download URL
  ///
  /// Parameters:
  /// - filePath: Local file path of the image
  /// - storagePath: Destination path in Firebase Storage
  /// - imageType: Type of image (for error messages)
  ///
  /// Returns: Download URL of the uploaded image
  /// Throws: [RegistrationException] if upload fails
  Future<String> _uploadImage({
    required String filePath,
    required String storagePath,
    required String imageType,
  }) async {
    try {
      final File imageFile = File(filePath);

      if (!imageFile.existsSync()) {
        throw RegistrationException(
          message: '$imageType image file not found at: $filePath',
        );
      }

      // Upload to Firebase Storage
      final Reference storageRef = _firebaseStorage.ref().child(storagePath);
      final UploadTask uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedAt': DateTime.now().toIso8601String(),
            'imageType': imageType,
          },
        ),
      );

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw RegistrationException(
        message: 'Failed to upload $imageType image: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw RegistrationException(
        message: 'Unexpected error uploading $imageType image: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Save user profile to Firestore
  ///
  /// Parameters:
  /// - phone: User's phone number (used as document ID)
  /// - userProfile: User profile data map
  ///
  /// Returns: User ID (phone number)
  /// Throws: [RegistrationException] if save fails
  Future<String> _saveUserProfile({
    required String phone,
    required Map<String, dynamic> userProfile,
  }) async {
    try {
      // Use phone as document ID for easier lookup
      final DocumentReference userDoc = _firebaseFirestore
          .collection(_usersCollection)
          .doc(phone);

      await userDoc.set(userProfile, SetOptions(merge: false));

      return phone;
    } on FirebaseException catch (e) {
      throw RegistrationException(
        message: 'Failed to save user profile to Firestore: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw RegistrationException(
        message: 'Unexpected error saving user profile: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Retrieve user profile from Firestore
  /// Throws: [RegistrationException] if retrieval fails
  Future<Map<String, dynamic>?> getUserProfile(String phone) async {
    try {
      final DocumentSnapshot doc = await _firebaseFirestore
          .collection(_usersCollection)
          .doc(phone)
          .get();

      if (!doc.exists) {
        return null;
      }

      return doc.data() as Map<String, dynamic>?;
    } on FirebaseException catch (e) {
      throw RegistrationException(
        message: 'Failed to retrieve user profile: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw RegistrationException(
        message: 'Unexpected error retrieving user profile: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Delete user registration (cleanup in case of failed registration)
  /// Throws: [RegistrationException] if deletion fails
  Future<void> deleteUserRegistration(String phone) async {
    try {
      // Delete from Firestore
      await _firebaseFirestore.collection(_usersCollection).doc(phone).delete();

      // Note: Storage files should be cleaned up separately if needed
    } on FirebaseException catch (e) {
      throw RegistrationException(
        message: 'Failed to delete user registration: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw RegistrationException(
        message: 'Unexpected error deleting user registration: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }
}
