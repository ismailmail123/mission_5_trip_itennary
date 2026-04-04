import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String gender;

  @HiveField(5)
  final String countryCode;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final String password;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.countryCode,
    this.createdAt,
    required this.password,
  });

  /// Factory method untuk membuat user dari data registrasi
  factory User.fromRegistration({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String countryCode,
    required String password,
  }) {
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      gender: gender,
      countryCode: countryCode,
      createdAt: DateTime.now(),
      password: password,
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
      password: json['password'] ?? '',
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
      'password': password,
    };
  }

  /// Validasi password
  bool validatePassword(String inputPassword) {
    return password == inputPassword;
  }

  /// CopyWith method
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? countryCode,
    DateTime? createdAt,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      countryCode: countryCode ?? this.countryCode,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'User(name: $name, email: $email, phone: $phone)';
  }
}