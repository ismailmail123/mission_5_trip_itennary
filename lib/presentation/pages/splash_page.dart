import 'package:flutter/material.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:trips/presentation/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/splashscreen';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashPage> {
  bool _isLoading = false;

  void _navigateToLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Wander",
                              style: AppTextStyles.h1(context).copyWith(fontSize: 32, fontWeight: FontWeight.w800, color: const Color.fromARGB(255, 51, 165, 218))),
                          Text("Ly",
                              style: AppTextStyles.h1(context).copyWith(fontSize: 32, fontWeight: FontWeight.w800, color: const Color.fromARGB(255, 164, 215, 239))),
                        ],
                      ),
                      Positioned(
                        top: -35,
                        child: Opacity(
                          opacity: 0.75,
                          child: Image.asset('assets/images/098c50d2b4f3e494b000428f0cb7997743e3f04b.png', width: 200, height: 200, fit: BoxFit.contain),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                if (_isLoading) ...[
                  SizedBox(height: 48),
                  CircularProgressIndicator(color: colors.primary, strokeWidth: 2),
                ],
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: colors.spalshNavigation,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Explore the world effortlessly",
                      style: AppTextStyles.bodyMd(context).copyWith(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  SizedBox(height: 32),
                  _isLoading
                      ? CircularProgressIndicator(color: colors.primary, strokeWidth: 2)
                      : IconButton(
                    onPressed: _navigateToLogin,
                    icon: Icon(Icons.arrow_circle_right_outlined, color: colors.textPrimary, fontWeight: FontWeight.w100, size: 70),
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
