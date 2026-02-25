import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trips/screens/main_screen.dart';
import 'package:trips/screens/splash_screen.dart';
import 'package:trips/screens/login_screen.dart';
import 'package:trips/screens/register_screen.dart';
import 'package:trips/services/hive_service.dart';
import 'package:trips/services/trip_service.dart';
import 'package:trips/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:trips/providers/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ INISIALISASI HIVE
  await Hive.initFlutter();
  await HiveService.init();
  await HiveTripService.init();

  // ✅ RESET DAN INITIAL DATA TRIP (hapus dulu, create ulang)
  //{Inline Review: Reset pada startup membuat data user tidak persisten antar sesi aplikasi.}
  await HiveTripService.resetAndInitialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeController = ref.read(themeProvider.notifier);

    // Tampilkan loading screen
    if (themeState.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.light.background,
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.light.primary,
            ),
          ),
        ),
      );
    }

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Trips',
          themeMode: themeState.themeMode,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          home: SplashScreen(
            onThemeToggle: themeController.toggleTheme,
            themeIcon: themeState.getThemeIcon(),
            themeDescription: themeState.getThemeDescription(),
            isDarkMode: themeState.isDarkMode(),
          ),
          routes: {
            SplashScreen.routeName: (context) => SplashScreen(
              onThemeToggle: themeController.toggleTheme,
              themeIcon: themeState.getThemeIcon(),
              themeDescription: themeState.getThemeDescription(),
              isDarkMode: themeState.isDarkMode(),
            ),
            LoginScreen.routeName: (context) => LoginScreen(
              onThemeToggle: themeController.toggleTheme,
              themeIcon: themeState.getThemeIcon(),
              themeDescription: themeState.getThemeDescription(),
              isDarkMode: themeState.isDarkMode(),
            ),
            RegisterScreen.routeName: (context) => RegisterScreen(
              onThemeToggle: themeController.toggleTheme,
              themeIcon: themeState.getThemeIcon(),
              themeDescription: themeState.getThemeDescription(),
              isDarkMode: themeState.isDarkMode(),
            ),
            MainScreen.routeName: (context) => MainScreen(
              onThemeToggle: themeController.toggleTheme,
              themeIcon: themeState.getThemeIcon(),
              themeDescription: themeState.getThemeDescription(),
              isDarkMode: themeState.isDarkMode(),
            ),
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    final colors = AppColors.light;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        primaryContainer: colors.primaryVariant,
        secondary: colors.primaryVariant,
        secondaryContainer: colors.primaryVariant.withOpacity(0.2),
        surface: colors.surface,
        background: colors.background,
        error: colors.error,
        onPrimary: colors.onPrimary,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 32.sp,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: colors.onPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          textStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final colors = AppColors.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        primaryContainer: colors.primaryVariant,
        secondary: colors.primaryVariant,
        secondaryContainer: colors.primaryVariant.withOpacity(0.2),
        surface: colors.surface,
        background: colors.background,
        error: colors.error,
        onPrimary: colors.onPrimary,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 32.sp,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: colors.onPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          textStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
