class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String password; // Terenkripsi/hashed di database
  final String pin;      // 6-digit PIN untuk validasi transaksi
  final String? fullName;
  final String? email;
  final String? nik;
  final String? alamat;
  final String? kycStatus;
  final String? selfieImageUrl;
  final String? ktpImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.password,
    required this.pin,
    this.fullName,
    this.email,
    this.nik,
    this.alamat,
    this.kycStatus,
    this.selfieImageUrl,
    this.ktpImageUrl,
  });

  // Membongkar JSON dari database menjadi Object Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      password: json['password'] as String,
      pin: json['pin'] as String,
      fullName: json['fullName'],
      email: json['email'],
      nik: json['nik'],
      alamat: json['alamat'],
      kycStatus: json['kycStatus'],
      selfieImageUrl: json['selfieImageUrl'],
      ktpImageUrl: json['ktpImageUrl'],
    );
  }

  // Mengubah Object Dart menjadi JSON untuk disimpan ke database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'password': password,
      'pin': pin,
      'fullName': fullName,
      'email': email,
      'nik': nik,
      'alamat': alamat,
      'kycStatus': kycStatus,
      'selfieImageUrl': selfieImageUrl,
      'ktpImageUrl': ktpImageUrl,
    };
  }
}