import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/models/user.dart';
import 'package:trips/providers/auth/auth_state.dart';
import 'package:trips/services/hive_service.dart';

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkSession();
    return AuthState.initial();
  }

  // ==================== CEK SESSION ====================
  Future<void> _checkSession() async {
    try {
      final currentUser = await HiveService.getCurrentUser();
      if (currentUser != null) {
        state = state.copyWith(
          user: currentUser, // ✅ LANGSUNG PAKAI USER, TIDAK PERLU fromUserModel
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // ==================== LOGIN DENGAN HIVE ====================
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await HiveService.loginUser(email, password); // ✅ RETURNS User

      if (user != null) {
        state = state.copyWith(
          user: user, // ✅ LANGSUNG PAKAI USER
          isLoading: false,
          error: null,
          isAuthenticated: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid email or password',
          isAuthenticated: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
      return false;
    }
  }

  // ==================== REGISTER DENGAN HIVE ====================
  Future<bool> register(User newUser) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final savedUser = await HiveService.registerUser(newUser);

      if (savedUser != null) {
        state = state.copyWith(
          user: savedUser, // ✅ LANGSUNG PAKAI USER
          isLoading: false,
          error: null,
          isAuthenticated: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Email already registered',
          isAuthenticated: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
      return false;
    }
  }

  // ==================== LOGOUT ====================
  Future<void> logout() async {
    await HiveService.logout();
    state = AuthState.initial();
  }

  // ==================== DELETE ACCOUNT ====================
  Future<void> deleteAccount() async {
    final currentUser = state.user;
    if (currentUser != null) {
      await HiveService.deleteUser(currentUser.id);
      await logout();
    }
  }
}

final authProvider = NotifierProvider<AuthController, AuthState>(
      () => AuthController(),
);