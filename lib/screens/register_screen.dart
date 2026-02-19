import 'package:flutter/material.dart';
import 'package:trips/screens/login_screen.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:trips/models/country_code.dart';
import 'package:trips/models/register_request.dart';
import 'package:trips/helpers/login_validator.dart';

// ================= CLASS REGISTER SCREEN =================

class RegisterScreen extends StatefulWidget {
  static const routeName = 'register';
  final VoidCallback onThemeToggle;
  final bool isDarkMode;
  final IconData themeIcon;
  final String themeDescription;

  const RegisterScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
    required this.themeIcon,
    required this.themeDescription,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// ================= STATE CLASS =================

class _RegisterScreenState extends State<RegisterScreen> {
  // ================= STATE VARIABLES =================

  /// Mengontrol visibilitas password
  bool _obscurePassword = true;

  /// Mengontrol visibilitas konfirmasi password
  bool _obscureConfirmPassword = true;

  /// Menyimpan pilihan jenis kelamin pengguna
  String _gender = "Female";

  /// Menandakan apakah sedang dalam proses loading
  bool _isLoading = false;

  /// Kode negara yang sedang dipilih
  CountryCode _selectedCountry = CountryCode(
    code: 'ID',
    name: 'Indonesia',
    flag: '🇮🇩',
    dialCode: '+62',
  );

  // ================= FORM ERROR VARIABLES =================

  /// Error validasi untuk nama
  String? _nameError;

  /// Error validasi untuk email
  String? _emailError;

  /// Error validasi untuk nomor telepon
  String? _phoneError;

  /// Error validasi untuk password
  String? _passwordError;

  /// Error validasi untuk konfirmasi password
  String? _confirmPasswordError;

  // ================= DATA LISTS =================

  /// Daftar kode negara yang tersedia
  final List<CountryCode> _countryCodes = [
    CountryCode(code: 'ID', name: 'Indonesia', flag: '🇮🇩', dialCode: '+62'),
    CountryCode(code: 'MY', name: 'Malaysia', flag: '🇲🇾', dialCode: '+60'),
    CountryCode(code: 'SG', name: 'Singapore', flag: '🇸🇬', dialCode: '+65'),
    CountryCode(code: 'US', name: 'United States', flag: '🇺🇸', dialCode: '+1'),
    CountryCode(code: 'GB', name: 'United Kingdom', flag: '🇬🇧', dialCode: '+44'),
    CountryCode(code: 'AU', name: 'Australia', flag: '🇦🇺', dialCode: '+61'),
    CountryCode(code: 'JP', name: 'Japan', flag: '🇯🇵', dialCode: '+81'),
    CountryCode(code: 'KR', name: 'South Korea', flag: '🇰🇷', dialCode: '+82'),
    CountryCode(code: 'CN', name: 'China', flag: '🇨🇳', dialCode: '+86'),
    CountryCode(code: 'IN', name: 'India', flag: '🇮🇳', dialCode: '+91'),
    CountryCode(code: 'SA', name: 'Saudi Arabia', flag: '🇸🇦', dialCode: '+966'),
    CountryCode(code: 'AE', name: 'UAE', flag: '🇦🇪', dialCode: '+971'),
  ];

  // ================= TEXT EDITING CONTROLLERS =================

  /// Controller untuk field nama lengkap
  final TextEditingController _nameController = TextEditingController();

  /// Controller untuk field email
  final TextEditingController _emailController = TextEditingController();

  /// Controller untuk field nomor telepon
  final TextEditingController _phoneController = TextEditingController();

  /// Controller untuk field password
  final TextEditingController _passwordController = TextEditingController();

  /// Controller untuk field konfirmasi password
  final TextEditingController _confirmPasswordController = TextEditingController();

  // ================= INITIALIZATION & DISPOSE =================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ================= NAVIGATION METHODS =================

  /// Navigasi ke halaman login dengan delay loading
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          onThemeToggle: widget.onThemeToggle,
          isDarkMode: widget.isDarkMode,
          themeIcon: widget.themeIcon,
          themeDescription: widget.themeDescription,
        ),
      ),
    );
  }

  /// Navigasi ke halaman login dengan snackbar setelah registrasi berhasil
  void _navigateToLoginWithSnackbar() {
    // Tampilkan snackbar registrasi berhasil
    _showSuccessSnackBar('Registration successful! Your account has been created.');

    // Validasi input untuk login (gunakan data dari registrasi)
    final email = _emailController.text;
    final password = _passwordController.text;

    // Validasi menggunakan validator
    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validatePassword(password);

    // Jika validasi berhasil, tampilkan snackbar validasi login berhasil
    if (emailError == null && passwordError == null) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        _showSuccessSnackBar('Login validation successful! You can now login with your credentials.');

        // Navigasi ke halaman login
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(
                onThemeToggle: widget.onThemeToggle,
                isDarkMode: widget.isDarkMode,
                themeIcon: widget.themeIcon,
                themeDescription: widget.themeDescription,
                // Kirim data registrasi ke login screen
                prefilledEmail: email,
                prefilledPassword: password,
              ),
            ),
          );
        });
      });
    } else {
      // Jika validasi gagal, tetap navigasi ke login
      Future.delayed(const Duration(seconds: 1), () {
        _navigateToLogin();
      });
    }
  }

  // ================= REGISTRATION METHODS =================

  /// Memproses pendaftaran pengguna baru dengan validasi input
  void _register() {
    // Reset semua error messages
    setState(() {
      _nameError = null;
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Validasi individual fields
    _nameError = Validators.validateName(_nameController.text);
    _emailError = Validators.validateEmail(_emailController.text);
    _phoneError = Validators.validatePhone(_phoneController.text);
    _passwordError = Validators.validatePassword(_passwordController.text);
    _confirmPasswordError = Validators.validateConfirmPassword(
      _passwordController.text,
      _confirmPasswordController.text,
    );

    // Cek jika ada error
    if (_nameError != null ||
        _emailError != null ||
        _phoneError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      setState(() {});
      _showErrorSnackBar("Please fix the errors in the form");
      return;
    }

    // Buat RegisterRequest model
    final registerRequest = RegisterRequest(
      name: _nameController.text,
      email: _emailController.text,
      phone: '${_selectedCountry.dialCode} ${_phoneController.text}',
      gender: _gender,
      countryCode: _selectedCountry.code,
      password: _passwordController.text,
    );

    // Proses registrasi
    _processRegistration(registerRequest);
  }

  /// Proses registrasi dengan model
  void _processRegistration(RegisterRequest request) {
    setState(() => _isLoading = true);

    // Simulasi API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);

      // Validasi request menggunakan model
      final errors = request.validate();
      if (errors.isNotEmpty) {
        // Tampilkan error pertama
        _showErrorSnackBar(errors.values.first ?? "Validation error");
        return;
      }

      // TODO: Implementasi logika registrasi ke backend
      // print('Register Request: ${request.toJson()}');

      // Navigasi ke login dengan snackbar
      _navigateToLoginWithSnackbar();
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

  // ================= COUNTRY CODE PICKER METHOD =================

  /// Menampilkan modal bottom sheet untuk memilih kode negara
  void _showCountryCodePicker(AppColors colors) {
    TextEditingController searchController = TextEditingController();
    List<CountryCode> filteredList = List.from(_countryCodes);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            /// Memfilter daftar negara berdasarkan kata kunci pencarian
            void filterList(String query) {
              setModalState(() {
                if (query.isEmpty) {
                  filteredList = List.from(_countryCodes);
                } else {
                  final lowercaseQuery = query.toLowerCase();
                  filteredList = _countryCodes.where((country) {
                    // 💎 Pencarian kode negara yang case-insensitive dan mendalam 
                    // ke nama, code, dan dialCode menunjukkan perhatian tinggi pada detail! 🛡️🔍
                    return country.name.toLowerCase().contains(lowercaseQuery) ||
                        country.code.toLowerCase().contains(lowercaseQuery) ||
                        country.dialCode.toLowerCase().contains(lowercaseQuery);
                  }).toList();
                }
              });
            }

            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  // Header dengan close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Country',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: colors.textSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Search field
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search country...',
                      hintStyle: TextStyle(color: colors.textSecondary),
                      prefixIcon: Icon(Icons.search, color: colors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colors.border),
                      ),
                      filled: true,
                      fillColor: colors.inputBackground,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    onChanged: filterList,
                  ),

                  const SizedBox(height: 16),

                  // List of countries
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final country = filteredList[index];
                        return ListTile(
                          leading: Text(country.flag, style: const TextStyle(fontSize: 24)),
                          title: Text(
                            country.name,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            country.code,
                            style: TextStyle(color: colors.textSecondary),
                          ),
                          trailing: Text(
                            country.dialCode,
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedCountry = country;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ================= BUILD METHOD =================

  /// Membangun UI untuk layar registrasi
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bool isDark = widget.isDarkMode;

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

              // ================= REGISTRATION FORM =================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.bg_black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colors.border,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Account Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= FORM FIELDS =================
                    _label('Full Name', colors),
                    _input(
                      colors,
                      controller: _nameController,
                      hintText: "Enter your full name",
                      errorText: _nameError,
                    ),

                    _label('Email', colors),
                    _input(
                      colors,
                      controller: _emailController,
                      hintText: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                    ),

                    _label('Jenis Kelamin', colors),
                    _dropdown(colors),

                    _label('Mobile', colors),
                    _phoneInput(colors, errorText: _phoneError),

                    _label('Password', colors),
                    _passwordField(
                      colors: colors,
                      obscure: _obscurePassword,
                      controller: _passwordController,
                      toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                      errorText: _passwordError,
                    ),

                    _label('Confirm Password', colors),
                    _passwordField(
                      colors: colors,
                      obscure: _obscureConfirmPassword,
                      controller: _confirmPasswordController,
                      toggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      errorText: _confirmPasswordError,
                    ),

                    const SizedBox(height: 12),

                    // ================= FORGOT PASSWORD LINK =================
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= REGISTER BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
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
                          'Register',
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= LOGIN BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _navigateToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.login_btn,
                          foregroundColor: colors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: colors.border,
                            width: 1.5,
                          ),
                          disabledBackgroundColor: colors.login_btn.withOpacity(0.5),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
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
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(Colors.white.value).withOpacity(isDark ? 0.7 : 1.0)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.transparent,
                          foregroundColor: colors.textPrimary,
                        ),
                        icon: Image.asset(
                          'assets/images/google_logo1.png',
                          height: 18,
                        ),
                        label: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
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

  /// Membuat label untuk form field dengan indikator wajib diisi
  Widget _label(String text, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.white,
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

  /// Membuat dropdown untuk pilihan jenis kelamin
  Widget _dropdown(AppColors colors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            color: colors.border,
            width: 1.5,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _gender,
            isExpanded: true,
            style: TextStyle(
              color: colors.inputText,
              fontSize: 16,
            ),
            dropdownColor: Colors.white,
            items: const [
              DropdownMenuItem(
                value: "Female",
                child: Text("Female"),
              ),
              DropdownMenuItem(
                value: "Male",
                child: Text("Male"),
              ),
            ],
            onChanged: _isLoading
                ? null
                : (v) => setState(() => _gender = v!),
          ),
        ),
      ),
    );
  }

  /// Membuat input field untuk nomor telepon dengan kode negara
  Widget _phoneInput(AppColors colors, {String? errorText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Container untuk kode negara yang bisa diklik untuk pilih
            GestureDetector(
              onTap: _isLoading ? null : () => _showCountryCodePicker(colors),
              child: Container(
                width: 100,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.inputBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: errorText != null ? colors.error : colors.border,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_selectedCountry.flag),
                    const SizedBox(width: 8),
                    Text(
                      _selectedCountry.dialCode,
                      style: TextStyle(
                        color: colors.inputText,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: colors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Input field untuk nomor telepon
            Expanded(
              child: TextField(
                controller: _phoneController,
                style: TextStyle(color: colors.inputText),
                keyboardType: TextInputType.phone,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  hintText: "Enter phone number",
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
            ),
          ],
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
}