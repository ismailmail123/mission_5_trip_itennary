// 💎 Memisahkan logic pendaftaran ke dalam `RegisterRequest` adalah 
// langkah cerdas dalam memisahkan state pendaftaran dan model User asli! 🛡️🏗️
class RegisterRequest {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String countryCode;
  final String password;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.countryCode,
    required this.password,
  });

  /// Validasi request
  Map<String, String?> validate() {
    // 💎 Logic validasi internal pada request model ini adalah praktik 
    // yang sangat baik untuk memastikan integritas data (Self-Validating Model)! 🛡️✨
    final errors = <String, String?>{};

    if (name.isEmpty) {
      errors['name'] = 'Full name is required';
    } else if (name.length < 3) {
      errors['name'] = 'Name must be at least 3 characters';
    }

    if (email.isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!_isValidEmail(email)) {
      errors['email'] = 'Please enter a valid email';
    }

    if (phone.isEmpty) {
      errors['phone'] = 'Phone number is required';
    }

    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    }

    return errors;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Convert ke JSON untuk API request
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'countryCode': countryCode,
      'password': password,
    };
  }
}