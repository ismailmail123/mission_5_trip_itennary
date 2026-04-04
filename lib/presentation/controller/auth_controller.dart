// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:trips/data/models/user.dart';
// import 'package:trips/presentation/controller/auth_state.dart';
// import 'package:trips/data/datasources/firestore_service.dart';
// import 'package:uuid/uuid.dart';
//
// class AuthController extends Notifier<AuthState> {
//   final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
//   final FirestoreService _firestoreService = FirestoreService();
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email', 'profile'],
//   );
//   final Uuid _uuid = const Uuid();
//
//   @override
//   AuthState build() {
//     _checkSession();
//     return AuthState.initial();
//   }
//
//   // ==================== CEK SESSION ====================
//   Future<void> _checkSession() async {
//     try {
//       final firebase_auth.User? firebaseUser = _auth.currentUser;
//       if (firebaseUser != null) {
//         final userData = await _firestoreService.getUser(firebaseUser.uid);
//         if (userData != null) {
//           state = state.copyWith(
//             user: userData,
//             isAuthenticated: true,
//             isLoading: false,
//           );
//         } else {
//           await logout();
//           state = state.copyWith(isLoading: false);
//         }
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
//   // ==================== CEK EMAIL DI FIRESTORE ====================
//   Future<bool> _isEmailExistsInFirestore(String email) async {
//     try {
//       print('🔍 FIRESTORE: Checking if email exists: $email');
//
//       // Gunakan method yang sudah ada di FirestoreService
//       final user = await _firestoreService.getUserByEmail(email);
//
//       if (user != null) {
//         print('✅ FIRESTORE: Email FOUND: ${user.email} with ID: ${user.id}');
//         return true;
//       } else {
//         print('❌ FIRESTORE: Email NOT found: $email');
//         return false;
//       }
//     } catch (e) {
//       print('❌ FIRESTORE: Error checking email: $e');
//       return false;
//     }
//   }
//
//   // ==================== LOGIN DENGAN EMAIL/PASSWORD ====================
//   Future<bool> login(String email, String password) async {
//     state = state.copyWith(isLoading: true, error: null);
//
//     try {
//       final firebase_auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       final firebase_auth.User? firebaseUser = userCredential.user;
//       if (firebaseUser != null) {
//         final userData = await _firestoreService.getUser(firebaseUser.uid);
//         if (userData != null) {
//           state = state.copyWith(
//             user: userData,
//             isLoading: false,
//             error: null,
//             isAuthenticated: true,
//           );
//           return true;
//         } else {
//           await _auth.signOut();
//           state = state.copyWith(
//             isLoading: false,
//             error: 'User data not found. Please register again.',
//             isAuthenticated: false,
//           );
//           return false;
//         }
//       }
//       return false;
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       String errorMessage;
//
//       switch (e.code) {
//         case 'user-not-found':
//           errorMessage = 'No user found with this email.';
//           break;
//         case 'wrong-password':
//           errorMessage = 'Wrong password. Please try again.';
//           break;
//         case 'invalid-email':
//           errorMessage = 'Invalid email format.';
//           break;
//         case 'user-disabled':
//           errorMessage = 'This account has been disabled.';
//           break;
//         case 'too-many-requests':
//           errorMessage = 'Too many failed login attempts. Try again later.';
//           break;
//         default:
//           errorMessage = e.message ?? 'Login failed';
//       }
//
//       state = state.copyWith(
//         isLoading: false,
//         error: errorMessage,
//         isAuthenticated: false,
//       );
//       return false;
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
//   // ==================== GET CURRENT USER ID ====================
//   String? getCurrentUserId() {
//     return _auth.currentUser?.uid;
//   }
//
//   // ==================== GET CURRENT USER ====================
//   User? getCurrentUser() {
//     return state.user;
//   }
//
//   // ==================== GET DISPLAY NAME ====================
//   String getDisplayName() {
//     final user = state.user;
//     if (user != null && user.name.isNotEmpty) {
//       return user.name.split(' ').first;
//     }
//
//     final firebaseUser = _auth.currentUser;
//     if (firebaseUser != null) {
//       if (firebaseUser.displayName != null && firebaseUser.displayName!.isNotEmpty) {
//         return firebaseUser.displayName!.split(' ').first;
//       }
//       if (firebaseUser.email != null) {
//         return firebaseUser.email!.split('@').first;
//       }
//     }
//
//     return 'Galileo';
//   }
//
//   // ==================== LOGIN DENGAN GOOGLE ====================
//   Future<bool> signInWithGoogle() async {
//     state = state.copyWith(isLoading: true, error: null);
//
//     try {
//       // Sign out dulu untuk memastikan fresh start
//       await _googleSignIn.signOut();
//
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//
//       if (googleUser == null) {
//         state = state.copyWith(
//           isLoading: false,
//           error: null,
//           isAuthenticated: false,
//         );
//         return false;
//       }
//
//       // ✅ CEK DI FIRESTORE: Apakah email sudah terdaftar?
//       final emailExists = await _isEmailExistsInFirestore(googleUser.email);
//
//       if (emailExists) {
//         // Email sudah terdaftar di Firestore, tolak login Google
//         await _googleSignIn.signOut();
//         state = state.copyWith(
//           isLoading: false,
//           error: 'This email is already registered. Please login using email and password.',
//           isAuthenticated: false,
//         );
//         return false;
//       }
//
//       // Jika email belum ada di Firestore, lanjutkan login Google
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//       final credential = firebase_auth.GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       try {
//         final firebase_auth.UserCredential userCredential =
//         await _auth.signInWithCredential(credential);
//
//         final firebase_auth.User? firebaseUser = userCredential.user;
//
//         if (firebaseUser != null) {
//           // Buat user baru di Firestore
//           final newUser = User(
//             id: firebaseUser.uid,
//             name: firebaseUser.displayName ?? googleUser.displayName ?? 'User',
//             email: firebaseUser.email ?? googleUser.email,
//             phone: '',
//             gender: '',
//             countryCode: '',
//             password: '',
//             createdAt: DateTime.now(),
//           );
//
//           await _firestoreService.saveUser(newUser);
//
//           state = state.copyWith(
//             user: newUser,
//             isLoading: false,
//             error: null,
//             isAuthenticated: true,
//           );
//           return true;
//         }
//       } on firebase_auth.FirebaseAuthException catch (e) {
//         if (e.code == 'account-exists-with-different-credential') {
//           // Fallback jika cek di Firestore gagal
//           await _googleSignIn.signOut();
//           state = state.copyWith(
//             isLoading: false,
//             error: 'This email is already registered. Please login using email and password.',
//             isAuthenticated: false,
//           );
//           return false;
//         } else {
//           rethrow;
//         }
//       }
//
//       return false;
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       String errorMessage;
//
//       switch (e.code) {
//         case 'invalid-credential':
//           errorMessage = 'Invalid Google credential.';
//           break;
//         case 'user-disabled':
//           errorMessage = 'This account has been disabled.';
//           break;
//         case 'too-many-requests':
//           errorMessage = 'Too many requests. Try again later.';
//           break;
//         case 'network-request-failed':
//           errorMessage = 'Network error. Please check your internet connection.';
//           break;
//         default:
//           errorMessage = e.message ?? 'Google Sign In failed';
//       }
//
//       state = state.copyWith(
//         isLoading: false,
//         error: errorMessage,
//         isAuthenticated: false,
//       );
//       return false;
//     } catch (e) {
//       print('Google Sign In Error: $e');
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Google Sign In failed. Please try again.',
//         isAuthenticated: false,
//       );
//       return false;
//     }
//   }
//
//   // ==================== REGISTER ====================
//   Future<bool> register(User newUser) async {
//     state = state.copyWith(isLoading: true, error: null);
//
//     try {
//       // ✅ CEK DI FIRESTORE: Apakah email sudah ada?
//       final emailExists = await _isEmailExistsInFirestore(newUser.email);
//
//       if (emailExists) {
//         state = state.copyWith(
//           isLoading: false,
//           error: 'This email is already registered. Please login instead.',
//           isAuthenticated: false,
//         );
//         return false;
//       }
//
//       // Coba register
//       final firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: newUser.email,
//         password: newUser.password,
//       );
//
//       final firebase_auth.User? firebaseUser = userCredential.user;
//       if (firebaseUser != null) {
//         final userWithUid = newUser.copyWith(id: firebaseUser.uid);
//         await _firestoreService.saveUser(userWithUid);
//
//         state = state.copyWith(
//           user: userWithUid,
//           isLoading: false,
//           error: null,
//           isAuthenticated: true,
//         );
//         return true;
//       }
//       return false;
//     } on firebase_auth.FirebaseAuthException catch (e) {
//       String errorMessage;
//
//       if (e.code == 'email-already-in-use') {
//         errorMessage = 'This email is already registered. Please login instead.';
//       } else {
//         switch (e.code) {
//           case 'invalid-email':
//             errorMessage = 'Invalid email format.';
//             break;
//           case 'weak-password':
//             errorMessage = 'Password is too weak. Please use at least 6 characters.';
//             break;
//           case 'operation-not-allowed':
//             errorMessage = 'Email/password registration is not enabled.';
//             break;
//           default:
//             errorMessage = e.message ?? 'Registration failed';
//         }
//       }
//
//       state = state.copyWith(
//         isLoading: false,
//         error: errorMessage,
//         isAuthenticated: false,
//       );
//       return false;
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
//     try {
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//     } catch (e) {
//       print('Error during logout: $e');
//     }
//     state = AuthState.initial();
//   }
//
//   // ==================== DELETE ACCOUNT ====================
//   Future<void> deleteAccount() async {
//     final currentUser = state.user;
//     if (currentUser != null) {
//       await _firestoreService.deleteUser(currentUser.id);
//       await _auth.currentUser?.delete();
//       await logout();
//     }
//   }
// }
//
// final authProvider = NotifierProvider<AuthController, AuthState>(
//       () => AuthController(),
// );


import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trips/data/models/user.dart';
import 'package:trips/presentation/controller/auth_state.dart';
import 'package:trips/data/datasources/firestore_service.dart';
import 'package:uuid/uuid.dart';

class AuthController extends Notifier<AuthState> {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final Uuid _uuid = const Uuid();

  @override
  AuthState build() {
    // Jangan panggil async function di build()
    // Gunakan WidgetsBinding untuk menjalankan setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
    return AuthState.initial();
  }

  // ==================== CEK SESSION ====================
  Future<void> _checkSession() async {
    // Jangan update state jika sudah tidak diperlukan
    if (state.isLoading) return;

    try {
      final firebase_auth.User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        final userData = await _firestoreService.getUser(firebaseUser.uid);
        if (userData != null) {
          state = state.copyWith(
            user: userData,
            isAuthenticated: true,
            isLoading: false,
          );
        } else {
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

  // ==================== CEK EMAIL DI FIRESTORE ====================
  Future<bool> _isEmailExistsInFirestore(String email) async {
    try {
      print('🔍 FIRESTORE: Checking if email exists: $email');

      final user = await _firestoreService.getUserByEmail(email);

      if (user != null) {
        print('✅ FIRESTORE: Email FOUND: ${user.email} with ID: ${user.id}');
        return true;
      } else {
        print('❌ FIRESTORE: Email NOT found: $email');
        return false;
      }
    } catch (e) {
      print('❌ FIRESTORE: Error checking email: $e');
      return false;
    }
  }

  // ==================== LOGIN DENGAN EMAIL/PASSWORD ====================
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final firebase_auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebase_auth.User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
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
          await _auth.signOut();
          state = state.copyWith(
            isLoading: false,
            error: 'User data not found. Please register again.',
            isAuthenticated: false,
          );
          return false;
        }
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed login attempts. Try again later.';
          break;
        default:
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

  // ==================== GET CURRENT USER ID ====================
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // ==================== GET CURRENT USER ====================
  User? getCurrentUser() {
    return state.user;
  }

  // ==================== GET DISPLAY NAME ====================
  String getDisplayName() {
    final user = state.user;
    if (user != null && user.name.isNotEmpty) {
      return user.name.split(' ').first;
    }

    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      if (firebaseUser.displayName != null && firebaseUser.displayName!.isNotEmpty) {
        return firebaseUser.displayName!.split(' ').first;
      }
      if (firebaseUser.email != null) {
        return firebaseUser.email!.split('@').first;
      }
    }

    return 'Galileo';
  }

  // ==================== LOGIN DENGAN GOOGLE ====================
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        state = state.copyWith(
          isLoading: false,
          error: null,
          isAuthenticated: false,
        );
        return false;
      }

      final emailExists = await _isEmailExistsInFirestore(googleUser.email);

      if (emailExists) {
        await _googleSignIn.signOut();
        state = state.copyWith(
          isLoading: false,
          error: 'This email is already registered. Please login using email and password.',
          isAuthenticated: false,
        );
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final firebase_auth.UserCredential userCredential = await _auth.signInWithCredential(credential);

        final firebase_auth.User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          final newUser = User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? googleUser.displayName ?? 'User',
            email: firebaseUser.email ?? googleUser.email,
            phone: '',
            gender: '',
            countryCode: '',
            password: '',
            createdAt: DateTime.now(),
          );

          await _firestoreService.saveUser(newUser);

          state = state.copyWith(
            user: newUser,
            isLoading: false,
            error: null,
            isAuthenticated: true,
          );
          return true;
        }
      } on firebase_auth.FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          await _googleSignIn.signOut();
          state = state.copyWith(
            isLoading: false,
            error: 'This email is already registered. Please login using email and password.',
            isAuthenticated: false,
          );
          return false;
        } else {
          rethrow;
        }
      }

      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-credential':
          errorMessage = 'Invalid Google credential.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Try again later.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = e.message ?? 'Google Sign In failed';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        isAuthenticated: false,
      );
      return false;
    } catch (e) {
      print('Google Sign In Error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Google Sign In failed. Please try again.',
        isAuthenticated: false,
      );
      return false;
    }
  }

  // ==================== REGISTER ====================
  Future<bool> register(User newUser) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final emailExists = await _isEmailExistsInFirestore(newUser.email);

      if (emailExists) {
        state = state.copyWith(
          isLoading: false,
          error: 'This email is already registered. Please login instead.',
          isAuthenticated: false,
        );
        return false;
      }

      final firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: newUser.email,
        password: newUser.password,
      );

      final firebase_auth.User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final userWithUid = newUser.copyWith(id: firebaseUser.uid);
        await _firestoreService.saveUser(userWithUid);

        state = state.copyWith(
          user: userWithUid,
          isLoading: false,
          error: null,
          isAuthenticated: true,
        );
        return true;
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already registered. Please login instead.';
      } else {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid email format.';
            break;
          case 'weak-password':
            errorMessage = 'Password is too weak. Please use at least 6 characters.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/password registration is not enabled.';
            break;
          default:
            errorMessage = e.message ?? 'Registration failed';
        }
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
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error during logout: $e');
    }
    state = AuthState.initial();
  }

  // ==================== DELETE ACCOUNT ====================
  Future<void> deleteAccount() async {
    final currentUser = state.user;
    if (currentUser != null) {
      await _firestoreService.deleteUser(currentUser.id);
      await _auth.currentUser?.delete();
      await logout();
    }
  }
}

final authProvider = NotifierProvider<AuthController, AuthState>(
      () => AuthController(),
);