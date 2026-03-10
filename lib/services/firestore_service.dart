import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trips/models/user.dart';

class FirestoreService {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');

  // Simpan data user
  Future<void> saveUser(User user) async {
    return await _usersCollection.doc(user.id).set(user.toJson());
  }

  // Ambil data user berdasarkan uid
  Future<User?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return User.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== GET ALL USERS ====================
  Future<List<User>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _usersCollection.get();
      return snapshot.docs.map((doc) {
        return User.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // ==================== GET USER BY EMAIL ====================
  Future<User?> getUserByEmail(String email) async {
    try {
      QuerySnapshot snapshot = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return User.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }

  // Hapus data user
  Future<void> deleteUser(String uid) async {
    return await _usersCollection.doc(uid).delete();
  }
}