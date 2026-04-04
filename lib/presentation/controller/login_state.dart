class LoginState {
  final String email;
  final String password;
  final bool obscurePassword;
  final bool rememberMe;
  final bool isLoading;
  final String? emailError;
  final String? passwordError;

  const LoginState({
    required this.email,
    required this.password,
    required this.obscurePassword,
    required this.rememberMe,
    required this.isLoading,
    this.emailError,
    this.passwordError,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    bool? rememberMe,
    bool? isLoading,
    String? emailError,
    String? passwordError,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError,
      passwordError: passwordError,
    );
  }

  static LoginState initial() => const LoginState(
    email: '',
    password: '',
    obscurePassword: true,
    rememberMe: false,
    isLoading: false,
    emailError: null,
    passwordError: null,
  );
}