// 💎 Penggunaan static methods untuk validator di class `Validators` 
// sangat memudahkan pemeliharaan kode (Centralized Logic). Mantap! 🛡️🎨
class Validators {
  /// Validasi email
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Email cannot be empty";
    }
    if (value.length < 3) {
      return "Email must be at least 3 characters";
    }
    // Email format validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  /// Validasi password
  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  /// Validasi nama
  static String? validateName(String value) {
    if (value.isEmpty) {
      return "Full name cannot be empty";
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

  /// Validasi nomor telepon
  static String? validatePhone(String value) {
    if (value.isEmpty) {
      return "Phone number cannot be empty";
    }
    // Hapus semua non-digit
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 8) {
      return "Please enter a valid phone number";
    }
    return null;
  }

  /// Validasi konfirmasi password
  static String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return "Please confirm your password";
    }
    if (password != confirmPassword) {
      return "Passwords do not match";
    }
    return null;
  }
}