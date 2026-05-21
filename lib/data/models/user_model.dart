class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String password; // Terenkripsi/hashed di database
  final String pin;      // 6-digit PIN untuk validasi transaksi

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.password,
    required this.pin,
  });

  // Membongkar JSON dari database menjadi Object Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      password: json['password'] as String,
      pin: json['pin'] as String,
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
    };
  }
}