// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:trips/providers/auth/auth_state.dart';
// import 'package:trips/screens/main_screen.dart';
// import 'package:trips/screens/splash_screen.dart';
// import 'package:trips/screens/login_screen.dart';
// import 'package:trips/screens/register_screen.dart';
// import 'package:trips/services/firestore_trip_service.dart';
// import 'package:trips/services/hive_service.dart';
// import 'package:trips/services/trip_service.dart';
// import 'package:trips/style/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sizer/sizer.dart';
// import 'package:trips/providers/theme/theme_controller.dart';
// import 'package:trips/providers/auth/auth_controller.dart';
//
// import 'models/trip_model.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Inisialisasi Firebase
//   await Firebase.initializeApp();
//
//   try {
//     final appDocDir = await getApplicationDocumentsDirectory();
//
//     // Hapus folder hive
//     final hiveDir = Directory('${appDocDir.path}/hive');
//     if (await hiveDir.exists()) {
//       await hiveDir.delete(recursive: true);
//       print('✅ Hive directory deleted: ${hiveDir.path}');
//     }
//
//     // Hapus file .hive di root
//     final files = await appDocDir.list().toList();
//     for (var file in files) {
//       if (file.path.endsWith('.hive') || file.path.endsWith('.lock')) {
//         await file.delete();
//         print('✅ Deleted: ${file.path}');
//       }
//     }
//
//     // Hapus di cache directory
//     final cacheDir = await getTemporaryDirectory();
//     final hiveCacheDir = Directory('${cacheDir.path}/hive');
//     if (await hiveCacheDir.exists()) {
//       await hiveCacheDir.delete(recursive: true);
//     }
//   } catch (e) {
//     print('Error deleting Hive files: $e');
//   }
//
//   // Inisialisasi Firebase
//   await Firebase.initializeApp();
//
//   // ✅ INISIALISASI HIVE
//   await Hive.initFlutter();
//
//   // Register adapter SEBELUM buka box
//   if (!Hive.isAdapterRegistered(1)) {
//     Hive.registerAdapter(TripModelAdapter());
//     print('✅ TripModelAdapter registered');
//   }
//
//   // ✅ BUAT ULANG SERVICE DENGAN DATA BARU
//   await HiveService.init();
//   await HiveTripService.init();
//
//   // ✅ RESET DAN INITIAL DATA TRIP
//   await HiveTripService.resetAndInitialize();
//
//   // ✅ INISIALISASI FIRESTORE TRIP SERVICE
//   final firestoreTripService = FirestoreTripService();
//   await firestoreTripService.initializeDefaultTrips();
//
//   runApp(const ProviderScope(child: MyApp()));
//
//
//   // ✅ INISIALISASI HIVE
//   await Hive.initFlutter();
//   await HiveService.init();
//   await HiveTripService.init();
//
//   // ✅ RESET DAN INITIAL DATA TRIP
//   await HiveTripService.resetAndInitialize();
//
//     await firestoreTripService.initializeDefaultTrips();
//
//   runApp(const ProviderScope(child: MyApp()));
// }
//
// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});
//
//   // Buat GlobalKey untuk navigator
//   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeState = ref.watch(themeProvider);
//     final themeController = ref.read(themeProvider.notifier);
//
//     // Pantau perubahan auth state
//     ref.listen<AuthState>(authProvider, (previous, next) {
//       if (!next.isLoading) {
//         if (next.isAuthenticated) {
//           // Jika login, navigasi ke MainScreen
//           navigatorKey.currentState?.pushReplacementNamed(MainScreen.routeName);
//         } else {
//           // Jika logout, navigasi ke Login Screen
//           navigatorKey.currentState?.pushReplacementNamed(LoginScreen.routeName);
//         }
//       }
//     });
//
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Trips',
//           themeMode: themeState.themeMode,
//           theme: _buildLightTheme(),
//           darkTheme: _buildDarkTheme(),
//           navigatorKey: navigatorKey,
//           initialRoute: SplashScreen.routeName,
//           routes: {
//             SplashScreen.routeName: (context) => SplashScreen(
//             ),
//             LoginScreen.routeName: (context) => LoginScreen(
//             ),
//             RegisterScreen.routeName: (context) => RegisterScreen(
//             ),
//             MainScreen.routeName: (context) => MainScreen(
//               onThemeToggle: themeController.toggleTheme,
//               themeIcon: themeState.getThemeIcon(),
//               themeDescription: themeState.getThemeDescription(),
//               isDarkMode: themeState.isDarkMode(),
//             ),
//           },
//         );
//       },
//     );
//   }
//
//   ThemeData _buildLightTheme() {
//     final colors = AppColors.light;
//
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//       colorScheme: ColorScheme.light(
//         primary: colors.primary,
//         primaryContainer: colors.primaryVariant,
//         secondary: colors.primaryVariant,
//         secondaryContainer: colors.primaryVariant.withOpacity(0.2),
//         surface: colors.surface,
//         background: colors.background,
//         error: colors.error,
//         onPrimary: colors.onPrimary,
//       ),
//       scaffoldBackgroundColor: colors.background,
//       appBarTheme: AppBarTheme(
//         backgroundColor: colors.background,
//         foregroundColor: colors.textPrimary,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: colors.textPrimary),
//         titleTextStyle: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 20.sp,
//           fontWeight: FontWeight.w600,
//           color: colors.textPrimary,
//         ),
//       ),
//       textTheme: TextTheme(
//         displayLarge: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 32.sp,
//           fontWeight: FontWeight.w700,
//           color: colors.textPrimary,
//         ),
//         displayMedium: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 28.sp,
//           fontWeight: FontWeight.w600,
//           color: colors.textPrimary,
//         ),
//         bodyLarge: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 16.sp,
//           fontWeight: FontWeight.w400,
//           color: colors.textPrimary,
//         ),
//         bodyMedium: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w400,
//           color: colors.textPrimary,
//         ),
//         labelLarge: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 16.sp,
//           fontWeight: FontWeight.w600,
//           color: colors.onPrimary,
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: colors.primary,
//           foregroundColor: colors.onPrimary,
//           textStyle: TextStyle(
//             fontFamily: 'Urbanist',
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: colors.surface,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: colors.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: colors.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: colors.primary, width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       ),
//       dividerTheme: DividerThemeData(
//         color: colors.divider,
//         thickness: 1,
//         space: 1,
//       ),
//     );
//   }
//
//   ThemeData _buildDarkTheme() {
//     final colors = AppColors.dark;
//
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.dark,
//       colorScheme: ColorScheme.dark(
//         primary: colors.primary,
//         primaryContainer: colors.primaryVariant,
//         secondary: colors.primaryVariant,
//         secondaryContainer: colors.primaryVariant.withOpacity(0.2),
//         surface: colors.surface,
//         background: colors.background,
//         error: colors.error,
//         onPrimary: colors.onPrimary,
//       ),
//       scaffoldBackgroundColor: colors.background,
//       appBarTheme: AppBarTheme(
//         backgroundColor: colors.background,
//         foregroundColor: colors.textPrimary,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: colors.textPrimary),
//         titleTextStyle: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 20.sp,
//           fontWeight: FontWeight.w600,
//           color: colors.textPrimary,
//         ),
//       ),
//       textTheme: TextTheme(
//         displayLarge: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 32.sp,
//           fontWeight: FontWeight.w700,
//           color: colors.textPrimary,
//         ),
//         displayMedium: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 28.sp,
//           fontWeight: FontWeight.w600,
//           color: colors.textPrimary,
//         ),
//         bodyLarge: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 16.sp,
//           fontWeight: FontWeight.w400,
//           color: colors.textPrimary,
//         ),
//         bodyMedium: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w400,
//           color: colors.textPrimary,
//         ),
//         labelLarge: TextStyle(
//           fontFamily: 'Urbanist',
//           fontSize: 16.sp,
//           fontWeight: FontWeight.w600,
//           color: colors.onPrimary,
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: colors.primary,
//           foregroundColor: colors.onPrimary,
//           textStyle: TextStyle(
//             fontFamily: 'Urbanist',
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: colors.surface,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: colors.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: colors.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: colors.primary, width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       ),
//       dividerTheme: DividerThemeData(
//         color: colors.divider,
//         thickness: 1,
//         space: 1,
//       ),
//     );
//   }
// }



import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trips/presentation/controller/auth_state.dart';
import 'package:trips/presentation/pages/main_page.dart';
import 'package:trips/presentation/pages/splash_page.dart';
import 'package:trips/presentation/pages/login_page.dart';
import 'package:trips/presentation/pages/register_page.dart';
import 'package:trips/data/datasources/firestore_trip_service.dart';
import 'package:trips/data/datasources/hive_service.dart';
import 'package:trips/data/datasources/trip_service.dart';
import 'package:trips/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:trips/presentation/controller/theme_controller.dart';
import 'package:trips/presentation/controller/auth_controller.dart';

import 'package:trips/data/models/trip_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp();

  try {
    final appDocDir = await getApplicationDocumentsDirectory();

    // Hapus folder hive
    final hiveDir = Directory('${appDocDir.path}/hive');
    if (await hiveDir.exists()) {
      await hiveDir.delete(recursive: true);
      print('✅ Hive directory deleted: ${hiveDir.path}');
    }

    // Hapus file .hive di root
    final files = await appDocDir.list().toList();
    for (var file in files) {
      if (file.path.endsWith('.hive') || file.path.endsWith('.lock')) {
        await file.delete();
        print('✅ Deleted: ${file.path}');
      }
    }

    // Hapus di cache directory
    final cacheDir = await getTemporaryDirectory();
    final hiveCacheDir = Directory('${cacheDir.path}/hive');
    if (await hiveCacheDir.exists()) {
      await hiveCacheDir.delete(recursive: true);
    }
  } catch (e) {
    print('Error deleting Hive files: $e');
  }

  // Inisialisasi Firebase
  await Firebase.initializeApp();

  // ✅ INISIALISASI HIVE
  await Hive.initFlutter();

  // Register adapter SEBELUM buka box
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TripModelAdapter());
    print('✅ TripModelAdapter registered');
  }

  // ✅ BUAT ULANG SERVICE DENGAN DATA BARU
  await HiveService.init();
  await HiveTripService.init();

  // ✅ RESET DAN INITIAL DATA TRIP
  await HiveTripService.resetAndInitialize();

  // ✅ INISIALISASI FIRESTORE TRIP SERVICE
  final firestoreTripService = FirestoreTripService();
  await firestoreTripService.initializeDefaultTrips();

  runApp(const ProviderScope(child: MyApp()));


  // ✅ INISIALISASI HIVE
  await Hive.initFlutter();
  await HiveService.init();
  await HiveTripService.init();

  // ✅ RESET DAN INITIAL DATA TRIP
  await HiveTripService.resetAndInitialize();

  await firestoreTripService.initializeDefaultTrips();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Buat GlobalKey untuk navigator
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeController = ref.read(themeProvider.notifier);

    // Pantau perubahan auth state
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!next.isLoading) {
        if (next.isAuthenticated) {
          // Jika login, navigasi ke MainScreen
          navigatorKey.currentState?.pushReplacementNamed(MainPage.routeName);
        } else {
          // Jika logout, navigasi ke Login Screen
          navigatorKey.currentState?.pushReplacementNamed(LoginPage.routeName);
        }
      }
    });

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Trips',
          themeMode: themeState.themeMode,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          navigatorKey: navigatorKey,
          initialRoute: SplashPage.routeName,
          routes: {
            SplashPage.routeName: (context) => SplashPage(
            ),
            LoginPage.routeName: (context) => LoginPage(
            ),
            RegisterPage.routeName: (context) => RegisterPage(
            ),
            MainPage.routeName: (context) => MainPage(
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