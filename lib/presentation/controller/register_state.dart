import 'package:trips/data/models/country_code.dart';

class RegisterState {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final CountryCode selectedCountry;
  final String password;
  final String confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;
  final String? nameError;
  final String? emailError;
  final String? phoneError;
  final String? passwordError;
  final String? confirmPasswordError;

  RegisterState({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.selectedCountry,
    required this.password,
    required this.confirmPassword,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isLoading,
    this.nameError,
    this.emailError,
    this.phoneError,
    this.passwordError,
    this.confirmPasswordError,
  });

  RegisterState copyWith({
    String? name,
    String? email,
    String? phone,
    String? gender,
    CountryCode? selectedCountry,
    String? password,
    String? confirmPassword,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isLoading,
    String? nameError,
    String? emailError,
    String? phoneError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      isLoading: isLoading ?? this.isLoading,
      nameError: nameError,
      emailError: emailError,
      phoneError: phoneError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
    );
  }

  static RegisterState initial() => RegisterState(
    name: '',
    email: '',
    phone: '',
    gender: 'Female',
    selectedCountry: const CountryCode(
      code: 'ID',
      name: 'Indonesia',
      flag: '🇮🇩',
      dialCode: '+62',
    ),
    password: '',
    confirmPassword: '',
    obscurePassword: true,
    obscureConfirmPassword: true,
    isLoading: false,
    nameError: null,
    emailError: null,
    phoneError: null,
    passwordError: null,
    confirmPasswordError: null,
  );
}