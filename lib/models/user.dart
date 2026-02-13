// 💎 Model `User` ini sangat pro dengan penggunaan factory `fromRegistration`. 
// Memudahkan pembuatan entitas user dari berbagai sumber data! 👤💎
// 💎 Model `User` ini sangat pro dengan penggunaan factory `fromRegistration`. 
// Memudahkan pembuatan entitas user dari berbagai sumber data! 👤💎
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String countryCode;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.countryCode,
    this.createdAt,
  });

  /// Factory method untuk membuat user dari data registrasi
  factory User.fromRegistration({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String countryCode,
  }) {
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      gender: gender,
      countryCode: countryCode,
      createdAt: DateTime.now(),
    );
  }

  /// Factory method untuk membuat dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      countryCode: json['countryCode'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'countryCode': countryCode,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User(name: $name, email: $email, phone: $phone)';
  }
}