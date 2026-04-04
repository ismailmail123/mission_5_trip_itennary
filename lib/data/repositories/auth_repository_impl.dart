import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trips/data/datasources/firestore_service.dart';
import 'package:trips/data/models/user.dart';
import 'package:trips/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  @override
  Future<User?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (credential.user != null) {
      return await _firestoreService.getUser(credential.user!.uid);
    }
    return null;
  }

  @override
  Future<User?> register(User user) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password);
    if (credential.user != null) {
      final userWithUid = user.copyWith(id: credential.user!.uid);
      await _firestoreService.saveUser(userWithUid);
      return userWithUid;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      return await _firestoreService.getUser(firebaseUser.uid);
    }
    return null;
  }

  @override
  Future<bool> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return false;
    final googleAuth = await googleUser.authentication;
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user != null;
  }
}
