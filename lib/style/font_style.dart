// import 'package:trips/style/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';
//
// enum FontEngine { local, google }
//
//
// class AppFonts {
//   static TextStyle base({
//     required FontEngine engine,
//     required double size,
//     FontWeight weight = FontWeight.normal,
//     double height = 1.4,
//     Color? color,
//   }) {
//     if (engine == FontEngine.google) {
//       return GoogleFonts.inter(
//         fontSize: size,
//         fontWeight: weight,
//         height: height,
//         color: color,
//       );
//     }
//
//     return TextStyle(
//       fontFamily: 'Inter',
//       fontSize: size,
//       fontWeight: weight,
//       height: height,
//       color: color,
//     );
//   }
// }
//
//
// class AppFontSizes {
//   const AppFontSizes._();
//
//
//   static double get h1 => 24.sp;
//   static double get h2 => 22.sp;
//   static double get h3 => 20.sp;
//
//
//   static double get bodyLg => 18.sp;
//   static double get bodyMd => 16.sp;
//   static double get bodySm => 14.sp;
//
//
//   static double get button => 16.sp;
//   static double get caption => 14.sp;
// }
//
//
// class AppLineHeights {
//   const AppLineHeights._(); // prevent instantiation
//
//   static double get tight => 1.2;
//
//   static double get normal => 1.4;
//
//   static double get relaxed => 1.6;
// }
//
//
// class AppTextStyles {
//   const AppTextStyles._();
//
//
//   static TextStyle h1(BuildContext context, FontEngine engine) {
//     final c = AppColors.of(context);
//     return AppFonts.base(
//       engine: engine,
//       size: AppFontSizes.h1,
//       weight: FontWeight.w700,
//       height: AppLineHeights.tight,
//       color: c.textPrimary,
//     );
//   }
//
//   static TextStyle h2(BuildContext context, FontEngine engine) {
//     final c = AppColors.of(context);
//     return AppFonts.base(
//       engine: engine,
//       size: AppFontSizes.h2,
//       weight: FontWeight.w700,
//       height: AppLineHeights.tight,
//       color: c.textPrimary,
//     );
//   }
//
//   static TextStyle h3(BuildContext context, FontEngine engine) {
//     final c = AppColors.of(context);
//     return AppFonts.base(
//       engine: engine,
//       size: AppFontSizes.h3,
//       weight: FontWeight.w600,
//       height: AppLineHeights.normal,
//       color: c.textPrimary,
//     );
//   }
//
//
//   static TextStyle bodyLg(BuildContext context, FontEngine engine) {
//     final c = AppColors.of(context);
//     return AppFonts.base(
//       engine: engine,
//       size: AppFontSizes.bodyLg,
//       weight: FontWeight.w400,
//       height: AppLineHeights.relaxed,
//       color: c.textPrimary,
//     );
//   }
//
//   static TextStyle bodyMd(BuildContext context, FontEngine engine) {
//     final c = AppColors.of(context);
//     return AppFonts.base(
//       engine: engine,
//       size: AppFontSizes.bodyMd,
//       weight: FontWeight.w400,
//       height: AppLineHeights.relaxed,
//       color: c.textPrimary,
//     );
//   }
//
//   static TextStyle bodySm(BuildContext context, FontEngine engine) {
//     final c = AppColors.of(context);
//     return AppFonts.base(
//       engine: engine,
//       size: AppFontSizes.bodySm,
//       weight: FontWeight.w400,
//       height: AppLineHeights.normal,
//       color: c.textSecondary,
//     );
//   }
//
//
//   static TextStyle caption(BuildContext context, FontEngine engine) {
//     final c = AppColors.of(context);
//     return AppFonts.base(
//       engine: engine,
//       size: AppFontSizes.caption,
//       weight: FontWeight.w400,
//       height: AppLineHeights.normal,
//       color: c.textSecondary,
//     );
//   }
//
//   static TextStyle button(FontEngine engine) {
//     return AppFonts.base(
//       engine: engine,
//       size: AppFontSizes.button,
//       weight: FontWeight.w600,
//       height: AppLineHeights.normal,
//       color: Colors.white,
//     );
//   }
//
//   static TextStyle bodyStrong(BuildContext context, FontEngine engine) {
//     final c = AppColors.of(context);
//     return AppFonts.base(
//       engine: engine,
//       size: AppFontSizes.bodyMd,
//       weight: FontWeight.w600,
//       height: AppLineHeights.normal,
//       color: c.textPrimary,
//     );
//   }
//
//   static TextStyle label(BuildContext context, FontEngine engine) {
//     final c = AppColors.of(context);
//     return AppFonts.base(
//       engine: engine,
//       size: AppFontSizes.bodySm,
//       weight: FontWeight.w500,
//       height: AppLineHeights.normal,
//       color: c.textPrimary,
//     );
//   }
// }


import 'package:trips/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

enum FontEngine { local, google }

// 💎 Sistem tipografi terpusat ini sangat mempermudah scaling aplikasi. 
// Kamu menggunakan `sizer` untuk font-size, ini adalah best practice industri! 📱📏
class AppFonts {
  static TextStyle base({
    required FontEngine engine,
    required double size,
    FontWeight weight = FontWeight.normal,
    double height = 1.4,
    Color? color,
    double? letterSpacing,
  }) {
    if (engine == FontEngine.google) {
      return GoogleFonts.urbanist(  // Ubah dari Inter ke Urbanist
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color,
        letterSpacing: letterSpacing,
      );
    }

    return TextStyle(
      fontFamily: 'Urbanist',  // Ubah dari Inter ke Urbanist
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}

class AppFontSizes {
  const AppFontSizes._();

  static double get h1 => 24.sp;
  static double get h2 => 22.sp;
  static double get h3 => 20.sp;

  static double get bodyLg => 18.sp;
  static double get bodyMd => 16.sp;
  static double get bodySm => 14.sp;

  static double get button => 16.sp;
  static double get caption => 12.sp; // Diperkecil sedikit
}

class AppLineHeights {
  const AppLineHeights._();

  static double get tight => 1.2;
  static double get normal => 1.4;
  static double get relaxed => 1.6;
}

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle h1(BuildContext context, {FontEngine engine = FontEngine.google}) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: AppFontSizes.h1,
      weight: FontWeight.w700,
      height: AppLineHeights.tight,
      color: c.textPrimary,
      letterSpacing: -0.5,
    );
  }

  static TextStyle h2(BuildContext context, {FontEngine engine = FontEngine.google}) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: AppFontSizes.h2,
      weight: FontWeight.w700,
      height: AppLineHeights.tight,
      color: c.textPrimary,
      letterSpacing: -0.5,
    );
  }

  static TextStyle h3(BuildContext context, {FontEngine engine = FontEngine.google}) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: AppFontSizes.h3,
      weight: FontWeight.w600,
      height: AppLineHeights.normal,
      color: c.textPrimary,
    );
  }

  static TextStyle bodyLg(BuildContext context, {FontEngine engine = FontEngine.google}) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: AppFontSizes.bodyLg,
      weight: FontWeight.w400,
      height: AppLineHeights.relaxed,
      color: c.textPrimary,
    );
  }

  static TextStyle bodyMd(BuildContext context, {FontEngine engine = FontEngine.google}) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: AppFontSizes.bodyMd,
      weight: FontWeight.w400,
      height: AppLineHeights.relaxed,
      color: c.textPrimary,
    );
  }

  static TextStyle bodySm(BuildContext context, {FontEngine engine = FontEngine.google}) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: AppFontSizes.bodySm,
      weight: FontWeight.w400,
      height: AppLineHeights.normal,
      color: c.textSecondary,
    );
  }

  static TextStyle caption(BuildContext context, {FontEngine engine = FontEngine.google}) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: AppFontSizes.caption,
      weight: FontWeight.w400,
      height: AppLineHeights.normal,
      color: c.textSecondary,
    );
  }

  static TextStyle button(BuildContext context, {FontEngine engine = FontEngine.google}) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: AppFontSizes.button,
      weight: FontWeight.w600,
      height: AppLineHeights.normal,
      color: c.onPrimary,
    );
  }

  static TextStyle bodyStrong(BuildContext context, {FontEngine engine = FontEngine.google}) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: AppFontSizes.bodyMd,
      weight: FontWeight.w600,
      height: AppLineHeights.normal,
      color: c.textPrimary,
    );
  }

  static TextStyle label(BuildContext context, {FontEngine engine = FontEngine.google}) {
    final c = AppColors.of(context);
    return AppFonts.base(
      engine: engine,
      size: AppFontSizes.bodySm,
      weight: FontWeight.w500,
      height: AppLineHeights.normal,
      color: c.textPrimary,
    );
  }
}
