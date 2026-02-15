// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:trips/models/user.dart';
// import 'package:trips/providers/auth/auth_state.dart';
// import 'package:trips/services/hive_service.dart';
//
// class AuthController extends Notifier<AuthState> {
//   @override
//   AuthState build() {
//     _checkSession();
//     return AuthState.initial();
//   }
//
//   // ==================== CEK SESSION ====================
//   Future<void> _checkSession() async {
//     try {
//       final currentUser = await HiveService.getCurrentUser();
//       if (currentUser != null) {
//         state = state.copyWith(
//           user: currentUser, // ✅ LANGSUNG PAKAI USER, TIDAK PERLU fromUserModel
//           isAuthenticated: true,
//           isLoading: false,
//         );
//       } else {
//         state = state.copyWith(isLoading: false);
//       }
//     } catch (e) {
//       state = state.copyWith(
//         error: e.toString(),
//         isLoading: false,
//       );
//     }
//   }
//
//   // ==================== LOGIN DENGAN HIVE ====================
//   Future<bool> login(String email, String password) async {
//     state = state.copyWith(isLoading: true, error: null);
//
//     try {
//       final user = await HiveService.loginUser(email, password); // ✅ RETURNS User
//
//       if (user != null) {
//         state = state.copyWith(
//           user: user, // ✅ LANGSUNG PAKAI USER
//           isLoading: false,
//           error: null,
//           isAuthenticated: true,
//         );
//         return true;
//       } else {
//         state = state.copyWith(
//           isLoading: false,
//           error: 'Invalid email or password',
//           isAuthenticated: false,
//         );
//         return false;
//       }
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//         isAuthenticated: false,
//       );
//       return false;
//     }
//   }
//
//   // ==================== REGISTER DENGAN HIVE ====================
//   Future<bool> register(User newUser) async {
//     state = state.copyWith(isLoading: true, error: null);
//
//     try {
//       final savedUser = await HiveService.registerUser(newUser);
//
//       if (savedUser != null) {
//         state = state.copyWith(
//           user: savedUser, // ✅ LANGSUNG PAKAI USER
//           isLoading: false,
//           error: null,
//           isAuthenticated: true,
//         );
//         return true;
//       } else {
//         state = state.copyWith(
//           isLoading: false,
//           error: 'Email already registered',
//           isAuthenticated: false,
//         );
//         return false;
//       }
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//         isAuthenticated: false,
//       );
//       return false;
//     }
//   }
//
//   // ==================== LOGOUT ====================
//   Future<void> logout() async {
//     await HiveService.logout();
//     state = AuthState.initial();
//   }
//
//   // ==================== DELETE ACCOUNT ====================
//   Future<void> deleteAccount() async {
//     final currentUser = state.user;
//     if (currentUser != null) {
//       await HiveService.deleteUser(currentUser.id);
//       await logout();
//     }
//   }
// }
//
// final authProvider = NotifierProvider<AuthController, AuthState>(
//       () => AuthController(),
// );


import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Beri alias
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/models/user.dart'; // Model User Anda
import 'package:trips/providers/auth/auth_state.dart';
import 'package:trips/services/firestore_service.dart';

class AuthController extends Notifier<AuthState> {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance; // Gunakan alias
  final FirestoreService _firestoreService = FirestoreService();

  @override
  AuthState build() {
    _checkSession();
    return AuthState.initial();
  }

  // ==================== CEK SESSION ====================
  Future<void> _checkSession() async {
    try {
      final firebase_auth.User? firebaseUser = _auth.currentUser; // Gunakan alias
      if (firebaseUser != null) {
        // Ambil data user dari Firestore berdasarkan uid
        final userData = await _firestoreService.getUser(firebaseUser.uid);
        if (userData != null) {
          state = state.copyWith(
            user: userData,
            isAuthenticated: true,
            isLoading: false,
          );
        } else {
          // Jika data tidak ada di Firestore, logout
          await logout();
          state = state.copyWith(isLoading: false);
        }
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

  // ==================== LOGIN DENGAN FIREBASE ====================
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final firebase_auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebase_auth.User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Ambil data user dari Firestore
        final userData = await _firestoreService.getUser(firebaseUser.uid);
        if (userData != null) {
          state = state.copyWith(
            user: userData,
            isLoading: false,
            error: null,
            isAuthenticated: true,
          );
          return true;
        } else {
          // Jika data profil tidak ada, logout
          await _auth.signOut();
          state = state.copyWith(
            isLoading: false,
            error: 'User data not found. Please register again.',
            isAuthenticated: false,
          );
          return false;
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Login failed',
          isAuthenticated: false,
        );
        return false;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = e.message ?? 'Login failed';
      }
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        isAuthenticated: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
      return false;
    }
  }

  // ==================== REGISTER DENGAN FIREBASE ====================
  Future<bool> register(User newUser) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Buat user di Firebase Auth dengan email dan password
      final firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: newUser.email,
        password: newUser.password,
      );

      final firebase_auth.User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Simpan data profil ke Firestore dengan uid sebagai document id
        final userWithUid = newUser.copyWith(id: firebaseUser.uid);
        await _firestoreService.saveUser(userWithUid);

        state = state.copyWith(
          user: userWithUid,
          isLoading: false,
          error: null,
          isAuthenticated: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Registration failed',
          isAuthenticated: false,
        );
        return false;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'The email address is already registered.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else {
        errorMessage = e.message ?? 'Registration failed';
      }
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        isAuthenticated: false,
      );
      return false;
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
    await _auth.signOut();
    state = AuthState.initial();
  }

  // ==================== DELETE ACCOUNT ====================
  Future<void> deleteAccount() async {
    final currentUser = state.user;
    if (currentUser != null) {
      // Hapus data dari Firestore
      await _firestoreService.deleteUser(currentUser.id);
      // Hapus user dari Firebase Auth
      await _auth.currentUser?.delete();
      await logout();
    }
  }
}

final authProvider = NotifierProvider<AuthController, AuthState>(
      () => AuthController(),
);