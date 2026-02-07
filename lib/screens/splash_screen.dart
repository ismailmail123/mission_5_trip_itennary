import 'package:flutter/material.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:trips/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashscreen';
  final VoidCallback onThemeToggle;
  final IconData themeIcon;
  final String themeDescription;
  final bool isDarkMode;

  const SplashScreen({
    super.key,
    required this.onThemeToggle,
    required this.themeIcon,
    required this.themeDescription,
    required this.isDarkMode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  bool _isLoading = false;

  void _navigateToLogin() {
    setState(() {
      _isLoading = true;
    });

    // Memberikan sedikit delay untuk animasi loading
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            onThemeToggle: widget.onThemeToggle,
            themeIcon: widget.themeIcon,
            themeDescription: widget.themeDescription,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Konten utama di tengah
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo atau icon
                Container(
                  width: 160,
                  height: 160,
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
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: const Color.fromARGB(255, 51, 165, 218),
                        ),
                      ),
                          Text(
                            "Ly",
                            style: AppTextStyles.h1(context).copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromARGB(255, 164, 215, 239),
                            ),
                          ),
                        ],
                      ),

                      // GAMBAR DIGESER KE ATAS
                      Positioned(
                        top: -35,
                        child: Opacity(
                          opacity: 0.75,
                          child: Image.asset(
                            'assets/images/098c50d2b4f3e494b000428f0cb7997743e3f04b.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Loading indicator hanya muncul saat tombol ditekan
                if (_isLoading) ...[
                  SizedBox(height: 48),
                  CircularProgressIndicator(
                    color: colors.primary,
                    strokeWidth: 2,
                  ),
                ],
              ],
            ),
          ),

          // Kontainer putih di bagian bawah dengan radius di kedua sisi atas
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: colors.spalshNavigation,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tagline di dalam kontainer putih
                  Text(
                    "Explore the world effortlessly",
                    style: AppTextStyles.bodyMd(context).copyWith(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  SizedBox(height: 32),

                  // Tombol dengan kondisi loading
                  _isLoading
                      ? CircularProgressIndicator(
                          color: colors.primary,
                          strokeWidth: 2,
                        )
                      : IconButton(
                          onPressed: _navigateToLogin,
                          icon: Icon(
                            Icons.arrow_circle_right_outlined,
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w100,
                            size: 70,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

