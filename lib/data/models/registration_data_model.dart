/// Model to hold temporary registration data across KYC flow screens
class RegistrationDataModel {
  /// User's phone number (from SignUpScreen)
  final String phone;

  /// User's password (from SignUpScreen) - NOT stored in Firestore for security
  final String password;

  /// User's full name (from DataPersonalScreen)
  final String fullName;

  /// User's email (from DataPersonalScreen)
  final String email;

  /// User's NIK identity number (from DataPersonalScreen)
  final String nik;

  /// User's full address (from DataPersonalScreen)
  final String alamat;

  /// Local file path to KTP image (from KtpScannerScreen)
  final String ktpImagePath;

  /// Local file path to selfie image (from FaceScannerScreen)
  final String selfieImagePath;

  // ===========================================================================
  // CONSTRUCTOR: Diubah menjadi opsional dengan nilai default '' (String Kosong)
  // agar halaman SignUp tidak error saat baru membuat koper data ini.
  // ===========================================================================
  RegistrationDataModel({
    required this.phone,
    required this.password,
    this.fullName = '',
    this.email = '',
    this.nik = '',
    this.alamat = '',
    this.ktpImagePath = '',
    this.selfieImagePath = '',
  });

  /// Convert model to JSON (excludes password for security)
  /// Password should only be used during authentication, never stored
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'fullName': fullName,
      'email': email,
      'nik': nik,
      'alamat': alamat,
      'ktpImagePath': ktpImagePath,
      'selfieImagePath': selfieImagePath,
    };
  }

  /// Create RegistrationDataModel from JSON
  factory RegistrationDataModel.fromJson(Map<String, dynamic> json) {
    return RegistrationDataModel(
      phone: json['phone'] as String? ?? '',
      password: json['password'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      nik: json['nik'] as String? ?? '',
      alamat: json['alamat'] as String? ?? '',
      ktpImagePath: json['ktpImagePath'] as String? ?? '',
      selfieImagePath: json['selfieImagePath'] as String? ?? '',
    );
  }

  /// Create a copy of this model with optional field overrides
  RegistrationDataModel copyWith({
    String? phone,
    String? password,
    String? fullName,
    String? email,
    String? nik,
    String? alamat,
    String? ktpImagePath,
    String? selfieImagePath,
  }) {
    return RegistrationDataModel(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      nik: nik ?? this.nik,
      alamat: alamat ?? this.alamat,
      ktpImagePath: ktpImagePath ?? this.ktpImagePath,
      selfieImagePath: selfieImagePath ?? this.selfieImagePath,
    );
  }

  @override
  String toString() {
    return 'RegistrationDataModel('
        'phone: $phone, '
        'fullName: $fullName, '
        'email: $email, '
        'nik: $nik, '
        'alamat: $alamat, '
        'ktpImagePath: $ktpImagePath, '
        'selfieImagePath: $selfieImagePath'
        ')';
  }
}
