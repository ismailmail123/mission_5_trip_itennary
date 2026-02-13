// import 'package:flutter/material.dart';
//
// class AppColors {
//   final Color background;
//   final Color surface;
//   final Color textPrimary;
//   final Color textSecondary;
//   final Color primary;
//   final Color divider;
//   final Color shadow;
//   final Color onPrimary;
//   final Color success;
//   final Color border;
//   final Color error;
//
//   const AppColors({
//     required this.background,
//     required this.surface,
//     required this.textPrimary,
//     required this.textSecondary,
//     required this.primary,
//     required this.divider,
//     required this.shadow,
//     required this.onPrimary,
//     required this.success,
//     required this.border,
//     required this.error,
//   });
//
//   static AppColors of(BuildContext context) {
//     return Theme.of(context).brightness == Brightness.dark ? dark : light;
//   }
//
//   static const light = AppColors(
//     background: Color(0xFFF9FAFB),
//     surface: Color(0xFFFFFFFF),
//     textPrimary: Color(0xFF1A1A1A),
//     textSecondary: Color(0xFF6B7280),
//     primary: Color(0xFF6B8AFE),
//     divider: Color(0xFFE5E7EB),
//     shadow: Color(0x1A000000),
//     onPrimary: Colors.white,
//     success: Color(0xFF16A34A),
//     border: Color(0xFFE5E7EB),
//     error: Color(0xFFDC2626),
//   );
//
//   static const dark = AppColors(
//     background: Color(0xFF121417),
//     surface: Color(0xFF1C1F24),
//     textPrimary: Color(0xFFE6E6E6),
//     textSecondary: Color(0xFF9CA3AF),
//     primary: Color(0xFF8FA8FF),
//     divider: Color(0xFF2A2E35),
//     shadow: Color(0x33000000),
//     onPrimary: Colors.black,
//     success: Color(0xFF22C55E),
//     border: Color(0xFF374151),
//     error: Color(0xFFF87171),
//   );
// }


import 'package:flutter/material.dart';

// 💎 Wow! Struktur `AppColors` ini sangat profesional. Pemisahan warna 
// per layer (primary, surface, background) memudahkan styling konsisten. 🎨💎
class AppColors {
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color primary;
  final Color primaryVariant; // 808EE4 untuk light mode
  final Color inputSearch;
  final Color divider;
  final Color shadow;
  final Color onPrimary;
  final Color success;
  final Color login_btn;
  final Color bg_black;
  final Color border;
  final Color error;
  final Color card;
  final Color nightLife;
  final Color hotelIcon;
  final Color iconShopping;
  final Color iconChinema;
  final Color cardInfo;
  final Color signinButton;
  final Color spalshNavigation;
  final Color socialButton;
  Color get inputBackground => Colors.white; // Selalu putih
  Color get inputText => Colors.black87; // Selalu gelap


  const AppColors({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.primary,
    required this.primaryVariant,
    required this.inputSearch,
    required this.divider,
    required this.shadow,
    required this.onPrimary,
    required this.success,
    required this.login_btn,
    required this.bg_black,
    required this.border,
    required this.error,
    required this.card,
    required this.nightLife,
    required this.hotelIcon,
    required this.iconShopping,
    required this.iconChinema, 
    required this.cardInfo,
    required this.signinButton,
    required this.socialButton,
    required this.spalshNavigation,
  });

  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  // 💎 Hebat! Sudah mendukung mode gelap (Dark Mode) dan terang (Light Mode) 
  // secara eksplisit dengan palet warna yang kontras dan nyaman di mata. 🌘🌖
  static const light = AppColors(
    background: Color(0xFFDBF7FF),    // Light blue background
    surface: Color(0xFFFFFFFF),       // White surface
    textPrimary: Color(0xFF1A1A1A),   // Almost black text
    textSecondary: Color(0xFF666666), // Gray text
    primary: Color(0xFF2F4BB9),       // Dark blue primary
    primaryVariant: Color(0xFF808EE4), // Light blue variant
    inputSearch: Color.fromARGB(255, 247, 244, 243),
    divider: Color(0xFFE0E0E0),
    shadow: Color(0x1A000000),
    onPrimary: Colors.white,
    success: Color(0xFF16A34A),
    login_btn: Color(0xCCEEFCE9),
    bg_black : Color(0xFF000000),
    border: Color(0xFFE0E0E0),
    error: Color(0xFFDC2626),
    card: Color(0xFFFFFFFF),
    nightLife: Color(0xFF000000),
    hotelIcon: Color(0xFF000000),
    iconShopping: Color(0xFF000000),
    iconChinema: Color(0xFF000000),
    cardInfo: Color(0xFFB0B0B0),
    signinButton: Color(0xFF2F4BB9),
    socialButton: Color(0xFFFFFFFF),
    spalshNavigation: Color(0xFFFFFFFF),

  );

  static const dark = AppColors(
    background: Color(0xFF102A43),    // Dark blue background
    surface: Color(0xFF1A365D),       // Slightly lighter surface
    textPrimary: Color(0xFFFFFFFF),   // White text
    textSecondary: Color(0xFFB0B0B0), // Light gray text
    primary: Color(0xFF4F6FDE),       // Bright blue primary
    primaryVariant: Color(0xFF6A7EE8), // Lighter blue variant
    inputSearch: Color(0xFF000000),
    divider: Color(0xFF2D3748),
    shadow: Color(0x33000000),
    onPrimary: Colors.white,
    success: Color(0xFF22C55E),
    login_btn: Color(0xCCEEFCE9),
    bg_black : Color(0xFF000000),
    border: Color(0xFF374151),
    error: Color(0xFFF87171),
    card: Color(0xFF000000),
    nightLife: Color(0xFFB8E6DF),
    hotelIcon: Color(0xFF374151),
    iconShopping: Color.fromARGB(255, 203, 140, 195),
    iconChinema: Color.fromARGB(255, 149, 141, 148),
    cardInfo: Color(0xFFFFFFFF),
    signinButton: Color(0xFF000000),
    socialButton: Color(0xFF000000),
    spalshNavigation: Color(0xFF000000),
  );
}
