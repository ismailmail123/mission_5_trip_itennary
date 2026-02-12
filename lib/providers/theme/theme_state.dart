import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode themeMode;
  final bool isLoading;

  const ThemeState({
    required this.themeMode,
    this.isLoading = false,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isLoading,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  static ThemeState initial() => const ThemeState(
    themeMode: ThemeMode.light,
    isLoading: true,
  );

  IconData getThemeIcon() {
    return themeMode == ThemeMode.light ? Icons.light_mode : Icons.dark_mode;
  }

  String getThemeDescription() {
    return themeMode == ThemeMode.light ? 'Light Mode' : 'Dark Mode';
  }

  bool isDarkMode() {
    return themeMode == ThemeMode.dark;
  }
}