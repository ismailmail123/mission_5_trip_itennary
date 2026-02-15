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

  // Hapus data user
  Future<void> deleteUser(String uid) async {
    return await _usersCollection.doc(uid).delete();
  }
}