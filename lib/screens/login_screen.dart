import 'package:flutter/material.dart';
import 'package:trips/screens/register_screen.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:trips/helpers/login_validator.dart';

import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';
  final VoidCallback onThemeToggle;
  final bool isDarkMode;
  final IconData themeIcon;
  final String themeDescription;
  final String? prefilledEmail;
  final String? prefilledPassword;

  const LoginScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
    required this.themeIcon,
    required this.themeDescription,
    this.prefilledEmail,
    this.prefilledPassword,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ================= STATE VARIABLES =================

  /// Controller untuk field username/email
  final TextEditingController _emailController = TextEditingController();

  /// Controller untuk field password
  final TextEditingController _passwordController = TextEditingController();

  /// Mengontrol visibilitas password
  bool _obscurePassword = true;

  /// Menandakan apakah sedang dalam proses loading
  bool _isLoading = false;

  /// Menyimpan nilai remember me
  bool _rememberMe = false;

  /// Error validasi untuk email
  String? _emailError;

  /// Error validasi untuk password
  String? _passwordError;

  // ================= INITIALIZATION =================

  @override
  void initState() {
    super.initState();
    // Prefill data jika ada dari register screen
    if (widget.prefilledEmail != null) {
      _emailController.text = widget.prefilledEmail!;
    }
    if (widget.prefilledPassword != null) {
      _passwordController.text = widget.prefilledPassword!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ================= NAVIGATION METHODS =================

  /// Navigasi ke halaman register dengan delay loading
  void _navigateToRegister() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterScreen(
            onThemeToggle: widget.onThemeToggle,
            isDarkMode: widget.isDarkMode,
            themeIcon: widget.themeIcon,
            themeDescription: widget.themeDescription,
          ),
        ),
      );
    });
  }

  // ================= LOGIN METHODS =================

  /// Memproses login pengguna dengan validasi input
  void _login() {
    // Reset error messages
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // Validasi email
    _emailError = Validators.validateEmail(_emailController.text);

    // Validasi password
    _passwordError = Validators.validatePassword(_passwordController.text);
    
    Navigator.pushReplacementNamed(
      context,
      MainScreen.routeName,
    );
    if (_emailError != null || _passwordError != null) {
      setState(() {});
      _showErrorSnackBar("Please fix the errors in the form");
      return;
    }

    // TODO: Implementasi logika login ke backend
    _processLogin();
  }

  /// Proses login dengan model
  void _processLogin() {
    setState(() => _isLoading = true);

    // Simulasi API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);

      // Simulasi login berhasil
      _showSuccessSnackBar("Login successful! Welcome back!");

      // TODO: Navigasi ke home screen setelah login berhasil
      // Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    });
  }

  /// Menampilkan snackbar error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Menampilkan snackbar success
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: AppColors.of(context).onPrimary),
        ),
        backgroundColor: AppColors.of(context).success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ================= BUILD METHODS =================

  /// Membangun UI untuk layar login
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bool isDark = widget.isDarkMode; // Gunakan dari widget, bukan late variable

    return Scaffold(
      backgroundColor: colors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.themeIcon,
              color: colors.textPrimary,
            ),
            tooltip: widget.themeDescription,
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 0,
          ),
          child: Column(
            children: [
              // ================= LOGO SECTION =================
              Container(
                width: 320,
                height: 220,
                margin: const EdgeInsets.only(top: 0, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Wander",
                          style: AppTextStyles.h1(context).copyWith(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: const Color.fromARGB(255, 51, 165, 218),
                          ),
                        ),
                        Text(
                          "Ly",
                          style: AppTextStyles.h1(context).copyWith(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: const Color.fromARGB(255, 164, 215, 239),
                          ),
                        ),
                      ],
                    ),

                    Positioned(
                      top: -75,
                      child: Opacity(
                        opacity: 0.75,
                        child: Image.asset(
                          'assets/images/098c50d2b4f3e494b000428f0cb7997743e3f04b.png',
                          width: 320,
                          height: 320,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

          Center(
                  child: Column(
                    children: [
                      Text(
                        "Didn't have account?",
                        style: AppTextStyles.bodyMd(context).copyWith(
                          color: colors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterScreen(
                                onThemeToggle: widget.onThemeToggle,
                                isDarkMode: widget.isDarkMode,
                                themeIcon: widget.themeIcon,
                                themeDescription: widget.themeDescription,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "create one here!",
                          style: AppTextStyles.bodyMd(context).copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

              // ================= LOGIN FORM =================
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(16),
                  // border: Border.all(
                  //   color: colors.border,
                  //   width: 1.5,
                  // ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= FORM FIELDS =================
                    _label('Email', colors),
                    _input(
                      colors,
                      controller: _emailController,
                      hintText: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                    ),

                    _label('Password', colors),
                    _passwordField(
                      colors: colors,
                      obscure: _obscurePassword,
                      controller: _passwordController,
                      toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                      errorText: _passwordError,
                    ),

                    const SizedBox(height: 12),

                    // ================= REMEMBER ME & FORGOT PASSWORD =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Remember Me Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: _isLoading
                                  ? null
                                  : (value) => setState(() => _rememberMe = value ?? false),
                              activeColor: colors.primary,
                              checkColor: colors.onPrimary,
                            ),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        // Forgot Password Link
                        GestureDetector(
                          onTap: _isLoading ? null : () {
                            _showSnackBar("Forgot password feature coming soon!");
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ================= LOGIN BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.bg_black,
                          foregroundColor: colors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBackgroundColor: colors.primary.withOpacity(0.5),
                        ),
                        child: _isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(colors.onPrimary),
                          ),
                        )
                            : Text(
                          'Login',
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),


                    const SizedBox(height: 20),

                    // ================= DIVIDER =================
                    Row(
                      children: [
                        Expanded(child: Divider(color: colors.divider)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Or',
                            style: TextStyle(color: colors.textSecondary),
                          ),
                        ),
                        Expanded(child: Divider(color: colors.divider)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ================= GOOGLE SIGN IN =================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : () {
                          _showSnackBar("Google sign in coming soon!");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: colors.socialButton,
                          foregroundColor: colors.textPrimary,
                        ),
                        icon: Image.asset(
                          'assets/images/google_logo1.png',
                          height: 18,
                        ),
                        label: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : () {
                          _showSnackBar("Google sign in coming soon!");
                        },
                        style: ElevatedButton.styleFrom(

                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: colors.socialButton,
                          foregroundColor: colors.textPrimary,
                        ),
                        icon: Icon(
                          Icons.apple_sharp,
                          size: 22,
                        ),
                        label: Text(
                          'Continue With Apple',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "By clicking continue, you agree to our ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: "Terms of Service and Privacy Policy",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI COMPONENT METHODS =================

  /// Membuat label untuk form field
  Widget _label(String text, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  /// Membuat input field text dengan styling yang konsisten
  Widget _input(
      AppColors colors, {
        required TextEditingController controller,
        String hintText = "",
        TextInputType keyboardType = TextInputType.text,
        String? errorText,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: TextStyle(color: colors.inputText),
          keyboardType: keyboardType,
          enabled: !_isLoading,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            hintText: hintText,
            hintStyle: TextStyle(color: colors.textSecondary.withOpacity(0.6)),
            filled: true,
            fillColor: colors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? colors.error : colors.border,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? colors.error : colors.border,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? colors.error : colors.primary,
                width: 1.5,
              ),
            ),
            errorText: errorText,
            errorStyle: TextStyle(
              color: colors.error,
              fontSize: 12,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colors.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Membuat input field password dengan toggle visibility
  Widget _passwordField({
    required AppColors colors,
    required bool obscure,
    required TextEditingController controller,
    required VoidCallback toggle,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(color: colors.inputText),
          enabled: !_isLoading,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            hintText: "Enter your password",
            hintStyle: TextStyle(color: colors.textSecondary.withOpacity(0.6)),
            filled: true,
            fillColor: colors.inputBackground,
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: colors.textSecondary,
              ),
              onPressed: _isLoading ? null : toggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? colors.error : colors.border,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? colors.error : colors.border,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? colors.error : colors.primary,
                width: 1.5,
              ),
            ),
            errorText: errorText,
            errorStyle: TextStyle(
              color: colors.error,
              fontSize: 12,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colors.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Menampilkan snackbar biasa
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.of(context).primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}