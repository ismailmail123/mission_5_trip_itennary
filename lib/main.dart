// // // import 'package:trips/screens/login_screen.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:sizer/sizer.dart';
// // //
// // // void main() {
// // //   runApp(const MyApp());
// // // }
// // //
// // // class MyApp extends StatelessWidget {
// // //   const MyApp({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Sizer(
// // //       builder: (context, orientation, deviceType) {
// // //         return MaterialApp(
// // //           debugShowCheckedModeBanner: false,
// // //           title: 'Trips',
// // //           themeMode: ThemeMode.system,
// // //           theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
// // //           darkTheme: ThemeData.light(),
// // //           home: LoginScreen(),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }
//
//
//
//
// // import 'package:trips/screens/login_screen.dart';
// // import 'package:trips/style/app_colors.dart';
// // import 'package:flutter/material.dart';
// // import 'package:sizer/sizer.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
//
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   runApp(const MyApp());
// // }
//
// // class MyApp extends StatefulWidget {
// //   const MyApp({super.key});
//
// //   @override
// //   State<MyApp> createState() => _MyAppState();
// // }
//
// // class _MyAppState extends State<MyApp> {
// //   ThemeMode _currentTheme = ThemeMode.light;
// //   bool _isLoading = true;
//
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeApp();
// //   }
//
// //   Future<void> _initializeApp() async {
// //     try {
// //       await Future.delayed(const Duration(milliseconds: 100));
// //       final prefs = await SharedPreferences.getInstance();
// //       final savedTheme = prefs.getString('theme_mode');
//
// //       if (savedTheme != null) {
// //         setState(() {
// //           _currentTheme = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
// //           _isLoading = false;
// //         });
// //       } else {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       print('Error initializing app: $e');
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }
//
// //   Future<void> _saveTheme(String themeValue) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString('theme_mode', themeValue);
// //       print('Theme saved: $themeValue');
// //     } catch (e) {
// //       print('Error saving theme: $e');
// //       // Coba lagi
// //       await Future.delayed(const Duration(milliseconds: 50));
// //       try {
// //         final prefs = await SharedPreferences.getInstance();
// //         await prefs.setString('theme_mode', themeValue);
// //       } catch (e2) {
// //         print('Failed after retry: $e2');
// //       }
// //     }
// //   }
//
// //   void _toggleTheme() {
// //     final newTheme = _currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//
// //     setState(() {
// //       _currentTheme = newTheme;
// //     });
//
// //     // Simpan tanpa await untuk non-blocking
// //     final themeValue = newTheme == ThemeMode.light ? 'light' : 'dark';
// //     _saveTheme(themeValue);
// //   }
//
// //   IconData _getThemeIcon() {
// //     return _currentTheme == ThemeMode.light ? Icons.light_mode : Icons.dark_mode;
// //   }
//
// //   String _getThemeDescription() {
// //     return _currentTheme == ThemeMode.light ? 'Light Mode' : 'Dark Mode';
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     if (_isLoading) {
// //       return MaterialApp(
// //         debugShowCheckedModeBanner: false,
// //         home: Scaffold(
// //           backgroundColor: AppColors.light.background,
// //           body: Center(
// //             child: CircularProgressIndicator(
// //               color: AppColors.light.primary,
// //             ),
// //           ),
// //         ),
// //       );
// //     }
//
// //     return Sizer(
// //       builder: (context, orientation, deviceType) {
// //         return MaterialApp(
// //           debugShowCheckedModeBanner: false,
// //           title: 'Trips',
// //           themeMode: _currentTheme,
// //           theme: _buildLightTheme(),
// //           darkTheme: _buildDarkTheme(),
// //           home: LoginScreen(
// //             onThemeToggle: _toggleTheme,
// //             themeIcon: _getThemeIcon(),
// //             themeDescription: _getThemeDescription(),
// //             isDarkMode: _currentTheme == ThemeMode.dark,
// //           ),
// //         );
// //       },
// //     );
// //   }
//
// //   ThemeData _buildLightTheme() {
// //     final colors = AppColors.light;
//
// //     return ThemeData(
// //       useMaterial3: true,
// //       brightness: Brightness.light,
// //       colorScheme: ColorScheme.light(
// //         primary: colors.primary,
// //         primaryContainer: colors.primaryVariant,
// //         secondary: colors.primaryVariant,
// //         secondaryContainer: colors.primaryVariant.withOpacity(0.2),
// //         surface: colors.surface,
// //         background: colors.background,
// //         error: colors.error,
// //         onPrimary: colors.onPrimary,
// //       ),
// //       scaffoldBackgroundColor: colors.background,
// //       appBarTheme: AppBarTheme(
// //         backgroundColor: colors.background,
// //         foregroundColor: colors.textPrimary,
// //         elevation: 0,
// //         centerTitle: true,
// //         iconTheme: IconThemeData(color: colors.textPrimary),
// //         titleTextStyle: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 20.sp,
// //           fontWeight: FontWeight.w600,
// //           color: colors.textPrimary,
// //         ),
// //       ),
// //       textTheme: TextTheme(
// //         displayLarge: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 32.sp,
// //           fontWeight: FontWeight.w700,
// //           color: colors.textPrimary,
// //         ),
// //         displayMedium: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 28.sp,
// //           fontWeight: FontWeight.w600,
// //           color: colors.textPrimary,
// //         ),
// //         bodyLarge: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 16.sp,
// //           fontWeight: FontWeight.w400,
// //           color: colors.textPrimary,
// //         ),
// //         bodyMedium: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 14.sp,
// //           fontWeight: FontWeight.w400,
// //           color: colors.textPrimary,
// //         ),
// //         labelLarge: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 16.sp,
// //           fontWeight: FontWeight.w600,
// //           color: colors.onPrimary,
// //         ),
// //       ),
// //       elevatedButtonTheme: ElevatedButtonThemeData(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: colors.primary,
// //           foregroundColor: colors.onPrimary,
// //           textStyle: TextStyle(
// //             fontFamily: 'Urbanist',
// //             fontSize: 16.sp,
// //             fontWeight: FontWeight.w600,
// //           ),
// //           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //         ),
// //       ),
// //       inputDecorationTheme: InputDecorationTheme(
// //         filled: true,
// //         fillColor: colors.surface,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: colors.border),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: colors.border),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: colors.primary, width: 2),
// //         ),
// //         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //       ),
// //       dividerTheme: DividerThemeData(
// //         color: colors.divider,
// //         thickness: 1,
// //         space: 1,
// //       ),
// //       // cardTheme: CardTheme(
// //       //   color: colors.surface,
// //       //   elevation: 2,
// //       //   shape: RoundedRectangleBorder(
// //       //     borderRadius: BorderRadius.circular(16),
// //       //   ),
// //       // ),
// //     );
// //   }
//
// //   ThemeData _buildDarkTheme() {
// //     final colors = AppColors.dark;
//
// //     return ThemeData(
// //       useMaterial3: true,
// //       brightness: Brightness.dark,
// //       colorScheme: ColorScheme.dark(
// //         primary: colors.primary,
// //         primaryContainer: colors.primaryVariant,
// //         secondary: colors.primaryVariant,
// //         secondaryContainer: colors.primaryVariant.withOpacity(0.2),
// //         surface: colors.surface,
// //         background: colors.background,
// //         error: colors.error,
// //         onPrimary: colors.onPrimary,
// //       ),
// //       scaffoldBackgroundColor: colors.background,
// //       appBarTheme: AppBarTheme(
// //         backgroundColor: colors.background,
// //         foregroundColor: colors.textPrimary,
// //         elevation: 0,
// //         centerTitle: true,
// //         iconTheme: IconThemeData(color: colors.textPrimary),
// //         titleTextStyle: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 20.sp,
// //           fontWeight: FontWeight.w600,
// //           color: colors.textPrimary,
// //         ),
// //       ),
// //       textTheme: TextTheme(
// //         displayLarge: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 32.sp,
// //           fontWeight: FontWeight.w700,
// //           color: colors.textPrimary,
// //         ),
// //         displayMedium: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 28.sp,
// //           fontWeight: FontWeight.w600,
// //           color: colors.textPrimary,
// //         ),
// //         bodyLarge: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 16.sp,
// //           fontWeight: FontWeight.w400,
// //           color: colors.textPrimary,
// //         ),
// //         bodyMedium: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 14.sp,
// //           fontWeight: FontWeight.w400,
// //           color: colors.textPrimary,
// //         ),
// //         labelLarge: TextStyle(
// //           fontFamily: 'Urbanist',
// //           fontSize: 16.sp,
// //           fontWeight: FontWeight.w600,
// //           color: colors.onPrimary,
// //         ),
// //       ),
// //       elevatedButtonTheme: ElevatedButtonThemeData(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: colors.primary,
// //           foregroundColor: colors.onPrimary,
// //           textStyle: TextStyle(
// //             fontFamily: 'Urbanist',
// //             fontSize: 16.sp,
// //             fontWeight: FontWeight.w600,
// //           ),
// //           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //         ),
// //       ),
// //       inputDecorationTheme: InputDecorationTheme(
// //         filled: true,
// //         fillColor: colors.surface,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: colors.border),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: colors.border),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: colors.primary, width: 2),
// //         ),
// //         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //       ),
// //       dividerTheme: DividerThemeData(
// //         color: colors.divider,
// //         thickness: 1,
// //         space: 1,
// //       ),
// //       // cardTheme: CardTheme(
// //       //   color: colors.surface,
// //       //   elevation: 2,
// //       //   shape: RoundedRectangleBorder(
// //       //     borderRadius: BorderRadius.circular(16),
// //       //   ),
// //       // ),
// //     );
// //   }
// // }
//
//
// import 'package:trips/screens/login_screen.dart';
// import 'package:trips/screens/splash_screen.dart';
// import 'package:trips/style/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:trips/helpers/theme_storage.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   ThemeMode _currentTheme = ThemeMode.light;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }
//
//   Future<void> _initializeApp() async {
//     try {
//       // Tunggu sedikit untuk memastikan engine siap
//       await Future.delayed(const Duration(milliseconds: 100));
//
//       // Baca tema dari local storage
//       final savedTheme = await ThemeStorage.readTheme();
//
//       setState(() {
//         _currentTheme = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error initializing app: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _toggleTheme() {
//     final newTheme = _currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//
//     setState(() {
//       _currentTheme = newTheme;
//     });
//
//     // Simpan tema tanpa await untuk non-blocking
//     final themeValue = newTheme == ThemeMode.light ? 'light' : 'dark';
//     ThemeStorage.writeTheme(themeValue); // Tanpa await
//   }
//
//   IconData _getThemeIcon() {
//     return _currentTheme == ThemeMode.light ? Icons.light_mode : Icons.dark_mode;
//   }
//
//   String _getThemeDescription() {
//     return _currentTheme == ThemeMode.light ? 'Light Mode' : 'Dark Mode';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           backgroundColor: AppColors.light.background,
//           body: Center(
//             child: CircularProgressIndicator(
//               color: AppColors.light.primary,
//             ),
//           ),
//         ),
//       );
//     }
//
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Trips',
//           themeMode: _currentTheme,
//           theme: _buildLightTheme(),
//           darkTheme: _buildDarkTheme(),
//           home: SplashScreen(
//             onThemeToggle: _toggleTheme,
//             themeIcon: _getThemeIcon(),
//             themeDescription: _getThemeDescription(),
//             isDarkMode: _currentTheme == ThemeMode.dark,
//           ),
//         );
//       },
//     );
//   }
//
//   // ... (fungsi _buildLightTheme dan _buildDarkTheme tetap sama)
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
//       // cardTheme: CardTheme(
//       //   color: colors.surface,
//       //   elevation: 2,
//       //   shape: RoundedRectangleBorder(
//       //     borderRadius: BorderRadius.circular(16),
//       //   ),
//       // ),
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
//       // cardTheme: CardTheme(
//       //   color: colors.surface,
//       //   elevation: 2,
//       //   shape: RoundedRectangleBorder(
//       //     borderRadius: BorderRadius.circular(16),
//       //   ),
//       // ),
//     );
//   }
// }

import 'package:trips/screens/main_screen.dart';
import 'package:trips/screens/splash_screen.dart';
import 'package:trips/screens/login_screen.dart';
import 'package:trips/screens/register_screen.dart';
import 'package:trips/screens/dashboard_screen.dart';
import 'package:trips/screens/trip_plan_screen.dart';
import 'package:trips/screens/manage_trips_screen.dart';
import 'package:trips/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:trips/helpers/theme_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _currentTheme = ThemeMode.light;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final savedTheme = await ThemeStorage.readTheme();

      setState(() {
        _currentTheme = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing app: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleTheme() {
    final newTheme = _currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    setState(() {
      _currentTheme = newTheme;
    });

    final themeValue = newTheme == ThemeMode.light ? 'light' : 'dark';
    ThemeStorage.writeTheme(themeValue);
  }

  IconData _getThemeIcon() {
    return _currentTheme == ThemeMode.light ? Icons.light_mode : Icons.dark_mode;
  }

  String _getThemeDescription() {
    return _currentTheme == ThemeMode.light ? 'Light Mode' : 'Dark Mode';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
          themeMode: _currentTheme,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          // Home adalah SplashScreen
          home: SplashScreen(
            onThemeToggle: _toggleTheme,
            themeIcon: _getThemeIcon(),
            themeDescription: _getThemeDescription(),
            isDarkMode: _currentTheme == ThemeMode.dark,
          ),
          // Routes untuk navigasi
          routes: {
            SplashScreen.routeName: (context) => SplashScreen(
              onThemeToggle: _toggleTheme,
              themeIcon: _getThemeIcon(),
              themeDescription: _getThemeDescription(),
              isDarkMode: _currentTheme == ThemeMode.dark,
            ),
            LoginScreen.routeName: (context) => LoginScreen(
              onThemeToggle: _toggleTheme,
              themeIcon: _getThemeIcon(),
              themeDescription: _getThemeDescription(),
              isDarkMode: _currentTheme == ThemeMode.dark,
            ),
            RegisterScreen.routeName: (context) => RegisterScreen(
              onThemeToggle: _toggleTheme,
              themeIcon: _getThemeIcon(),
              themeDescription: _getThemeDescription(),
              isDarkMode: _currentTheme == ThemeMode.dark,
            ),
            MainScreen.routeName: (context) => MainScreen(
              onThemeToggle: _toggleTheme,
              themeIcon: _getThemeIcon(),
              themeDescription: _getThemeDescription(),
              isDarkMode: _currentTheme == ThemeMode.dark,
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
