// import 'package:trips/models/user.dart';
//
// class AuthState {
//   final User? user;
//   final bool isLoading;
//   final String? error;
//
//   const AuthState({
//     this.user,
//     this.isLoading = false,
//     this.error,
//   });
//
//   AuthState copyWith({
//     User? user,
//     bool? isLoading,
//     String? error,
//   }) {
//     return AuthState(
//       user: user ?? this.user,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//     );
//   }
//
//   static AuthState initial() => const AuthState();
//
//   bool get isAuthenticated => user != null;
// }

import 'package:trips/models/user.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  static AuthState initial() => AuthState();
}