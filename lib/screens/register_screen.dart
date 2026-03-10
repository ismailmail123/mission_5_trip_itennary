import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/screens/login_screen.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:trips/models/country_code.dart';
import 'package:trips/models/user.dart';
import 'package:trips/providers/register/register_controller.dart';
import 'package:trips/providers/auth/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const routeName = 'register';

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final List<CountryCode> _countryCodes = const [
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

  @override
  void initState() {
    super.initState();
    final controller = ref.read(registerProvider.notifier);

    _nameController.addListener(() => controller.setName(_nameController.text));
    _emailController.addListener(() => controller.setEmail(_emailController.text));
    _phoneController.addListener(() => controller.setPhone(_phoneController.text));
    _passwordController.addListener(() => controller.setPassword(_passwordController.text));
    _confirmPasswordController.addListener(() => controller.setConfirmPassword(_confirmPasswordController.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(skipLoading: true), // tanpa parameter tema
      ),
    );
  }

  void _navigateToLoginWithSnackbar(String email, String password) {
    _showSuccessSnackBar('Registration successful! Your account has been created.');
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(prefilledEmail: email, prefilledPassword: password, skipLoading: true),
        ),
      );
    }
  }

  void _register() async {
    final registerController = ref.read(registerProvider.notifier);
    final authController = ref.read(authProvider.notifier);
    final registerState = ref.read(registerProvider);

    final isValid = registerController.validate();
    if (!isValid) {
      _showErrorSnackBar("Please fix the errors in the form");
      return;
    }

    final userModel = User.fromRegistration(
      name: registerState.name,
      email: registerState.email,
      phone: '${registerState.selectedCountry.dialCode} ${registerState.phone}',
      gender: registerState.gender,
      countryCode: registerState.selectedCountry.code,
      password: registerState.password,
    );

    registerController.setLoading(true);
    final success = await authController.register(userModel);
    registerController.setLoading(false);

    if (success) {
      if (mounted) {
        _navigateToLoginWithSnackbar(registerState.email, registerState.password);
      }
    } else {
      final error = ref.read(authProvider).error;
      if (error != null && error.contains('already registered')) {
        if (mounted) {
          _showErrorWithLoginOption(error);
        }
      } else {
        if (mounted) {
          _showErrorSnackBar(error ?? "Registration failed");
        }
      }
    }
  }
  void _showErrorWithLoginOption(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Already Registered'),
        content: Text('$message\n\nWould you like to login instead?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToLogin();
            },
            child: const Text('Login', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: AppColors.of(context).onPrimary)),
        backgroundColor: AppColors.of(context).success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCountryCodePicker(AppColors colors) {
    final controller = ref.read(registerProvider.notifier);
    TextEditingController searchController = TextEditingController();
    List<CountryCode> filteredList = List.from(_countryCodes);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void filterList(String query) {
              setModalState(() {
                if (query.isEmpty) {
                  filteredList = List.from(_countryCodes);
                } else {
                  final lowercaseQuery = query.toLowerCase();
                  filteredList = _countryCodes.where((country) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Country', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                      IconButton(icon: Icon(Icons.close, color: colors.textSecondary), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search country...',
                      hintStyle: TextStyle(color: colors.textSecondary),
                      prefixIcon: Icon(Icons.search, color: colors.textSecondary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colors.border)),
                      filled: true,
                      fillColor: colors.inputBackground,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    onChanged: filterList,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final country = filteredList[index];
                        return ListTile(
                          leading: Text(country.flag, style: const TextStyle(fontSize: 24)),
                          title: Text(country.name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w500)),
                          subtitle: Text(country.code, style: TextStyle(color: colors.textSecondary)),
                          trailing: Text(country.dialCode, style: TextStyle(color: colors.primary, fontWeight: FontWeight.w600)),
                          onTap: () {
                            controller.setSelectedCountry(country);
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final registerState = ref.watch(registerProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
          child: Column(
            children: [
              Container(
                width: 320,
                height: 220,
                margin: const EdgeInsets.only(top: 0, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Wander", style: AppTextStyles.h1(context).copyWith(fontSize: 42, fontWeight: FontWeight.w800, color: const Color.fromARGB(255, 51, 165, 218))),
                        Text("Ly", style: AppTextStyles.h1(context).copyWith(fontSize: 42, fontWeight: FontWeight.w800, color: const Color.fromARGB(255, 164, 215, 239))),
                      ],
                    ),
                    Positioned(
                      top: -75,
                      child: Opacity(
                        opacity: 0.75,
                        child: Image.asset('assets/images/098c50d2b4f3e494b000428f0cb7997743e3f04b.png', width: 320, height: 320, fit: BoxFit.contain),
                      ),
                    ),
                  ],
                ),
              ),

              // Registration Form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.bg_black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('Account Register', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 24),

                    _label('Full Name', colors),
                    _input(colors, controller: _nameController, hintText: "Enter your full name", errorText: registerState.nameError),

                    _label('Email', colors),
                    _input(colors, controller: _emailController, hintText: "Enter your email", keyboardType: TextInputType.emailAddress, errorText: registerState.emailError),

                    _label('Jenis Kelamin', colors),
                    _dropdown(colors, registerState.gender, (value) {
                      if (value != null) ref.read(registerProvider.notifier).setGender(value);
                    }),

                    _label('Mobile', colors),
                    _phoneInput(colors, errorText: registerState.phoneError),

                    _label('Password', colors),
                    _passwordField(
                      colors: colors,
                      obscure: registerState.obscurePassword,
                      controller: _passwordController,
                      toggle: () => ref.read(registerProvider.notifier).toggleObscurePassword(),
                      errorText: registerState.passwordError,
                    ),

                    _label('Confirm Password', colors),
                    _passwordField(
                      colors: colors,
                      obscure: registerState.obscureConfirmPassword,
                      controller: _confirmPasswordController,
                      toggle: () => ref.read(registerProvider.notifier).toggleObscureConfirmPassword(),
                      errorText: registerState.confirmPasswordError,
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('Forgot Password?', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: registerState.isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          disabledBackgroundColor: colors.primary.withOpacity(0.5),
                        ),
                        child: registerState.isLoading
                            ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(colors.onPrimary)))
                            : Text('Register', style: TextStyle(color: colors.onPrimary, fontWeight: FontWeight.w600)),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: registerState.isLoading ? null : _navigateToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.login_btn,
                          foregroundColor: colors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: colors.border, width: 1.5),
                          disabledBackgroundColor: colors.login_btn.withOpacity(0.5),
                        ),
                        child: Text('Login', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(child: Divider(color: colors.divider)),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('Or', style: TextStyle(color: colors.textSecondary))),
                        Expanded(child: Divider(color: colors.divider)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: registerState.isLoading ? null : () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(Colors.white.value).withOpacity(isDark ? 0.7 : 1.0)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.transparent,
                          foregroundColor: colors.textPrimary,
                        ),
                        icon: Image.asset('assets/images/google_logo1.png', height: 18),
                        label: Text('Sign in with Google', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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

  Widget _label(String text, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          children: const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
        ),
      ),
    );
  }

  Widget _input(AppColors colors,
      {required TextEditingController controller, String hintText = "", TextInputType keyboardType = TextInputType.text, String? errorText}) {
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
              borderSide: BorderSide(color: errorText != null ? colors.error : colors.border, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorText != null ? colors.error : colors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorText != null ? colors.error : colors.primary, width: 1.5),
            ),
            errorText: errorText,
            errorStyle: TextStyle(color: colors.error, fontSize: 12),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(AppColors colors, String value, ValueChanged<String?> onChanged) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, border: Border.all(color: colors.border, width: 1.5)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            style: TextStyle(color: colors.inputText, fontSize: 16),
            dropdownColor: Colors.white,
            items: const [
              DropdownMenuItem(value: "Female", child: Text("Female")),
              DropdownMenuItem(value: "Male", child: Text("Male")),
            ],
            onChanged: ref.watch(registerProvider).isLoading ? null : onChanged,
          ),
        ),
      ),
    );
  }

  Widget _phoneInput(AppColors colors, {String? errorText}) {
    final registerState = ref.watch(registerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: registerState.isLoading ? null : () => _showCountryCodePicker(colors),
              child: Container(
                width: 100,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.inputBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: errorText != null ? colors.error : colors.border, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(registerState.selectedCountry.flag),
                    const SizedBox(width: 8),
                    Text(registerState.selectedCountry.dialCode, style: TextStyle(color: colors.inputText, fontWeight: FontWeight.w500, fontSize: 14)),
                    Icon(Icons.arrow_drop_down, color: colors.textSecondary, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _phoneController,
                style: TextStyle(color: colors.inputText),
                keyboardType: TextInputType.phone,
                enabled: !registerState.isLoading,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  hintText: "Enter phone number",
                  hintStyle: TextStyle(color: colors.textSecondary.withOpacity(0.6)),
                  filled: true,
                  fillColor: colors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: errorText != null ? colors.error : colors.border, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: errorText != null ? colors.error : colors.border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: errorText != null ? colors.error : colors.primary, width: 1.5),
                  ),
                  errorText: errorText,
                  errorStyle: TextStyle(color: colors.error, fontSize: 12),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors.error, width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

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
          enabled: !ref.watch(registerProvider).isLoading,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            hintText: "Enter your password",
            hintStyle: TextStyle(color: colors.textSecondary.withOpacity(0.6)),
            filled: true,
            fillColor: colors.inputBackground,
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: colors.textSecondary),
              onPressed: ref.watch(registerProvider).isLoading ? null : toggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorText != null ? colors.error : colors.border, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorText != null ? colors.error : colors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorText != null ? colors.error : colors.primary, width: 1.5),
            ),
            errorText: errorText,
            errorStyle: TextStyle(color: colors.error, fontSize: 12),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}