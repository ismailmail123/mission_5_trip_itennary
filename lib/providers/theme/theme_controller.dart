import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/helpers/theme_storage.dart';
import 'package:trips/providers/theme/theme_state.dart';

class ThemeController extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    _loadTheme();
    return ThemeState.initial();
  }

  Future<void> _loadTheme() async {
    try {
      final savedTheme = await ThemeStorage.readTheme();
      final themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      state = state.copyWith(
        themeMode: themeMode,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        themeMode: ThemeMode.light,
        isLoading: false,
      );
    }
  }

  void toggleTheme() {
    final newTheme = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    state = state.copyWith(themeMode: newTheme);
    ThemeStorage.writeTheme(newTheme == ThemeMode.light ? 'light' : 'dark');
  }

  void setTheme(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
    ThemeStorage.writeTheme(themeMode == ThemeMode.light ? 'light' : 'dark');
  }
}

final themeProvider = NotifierProvider<ThemeController, ThemeState>(
      () => ThemeController(),
);