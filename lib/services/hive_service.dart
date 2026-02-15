import 'package:hive/hive.dart';
import 'package:trips/models/user.dart';

class HiveService {
  static const String userBoxName = 'users';
  static const String sessionBoxName = 'session';

  // ==================== INISIALISASI ====================
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    await Hive.openBox<User>(userBoxName);
    await Hive.openBox(sessionBoxName);
  }

  // ==================== REGISTER ====================
  static Future<User?> registerUser(User user) async {
    final box = Hive.box<User>(userBoxName);

    // CEK EMAIL SUDAH TERDAFTAR DENGAN AMAN
    try {
      final existingUser = box.values.firstWhere(
            (u) => u.email == user.email,
      );
      if (existingUser != null) return null; // Email sudah terdaftar
    } catch (e) {
      // Email tidak ditemukan, lanjut register
    }

    // Simpan user baru
    await box.put(user.id, user);
    return user;
  }

  // ==================== LOGIN ====================
  static Future<User?> loginUser(String email, String password) async {
    final box = Hive.box<User>(userBoxName);

    try {
      // ✅ CARI USER DENGAN AMAN
      final user = box.values.firstWhere(
            (u) => u.email == email,
      );

      if (user.validatePassword(password)) {
        await saveSession(user.id);
        return user;
      }
      return null; // Password salah
    } catch (e) {
      return null; // Email tidak ditemukan
    }
  }

  // ==================== SESSION ====================
  static Future<void> saveSession(String userId) async {
    final sessionBox = Hive.box(sessionBoxName);
    await sessionBox.put('currentUserId', userId);
    await sessionBox.put('lastLogin', DateTime.now().toIso8601String());
  }

  static Future<User?> getCurrentUser() async {
    final sessionBox = Hive.box(sessionBoxName);
    final userId = sessionBox.get('currentUserId');

    if (userId == null) return null;

    final userBox = Hive.box<User>(userBoxName);
    return userBox.get(userId);
  }

  // ==================== LOGOUT ====================
  static Future<void> logout() async {
    final sessionBox = Hive.box(sessionBoxName);
    await sessionBox.clear();
  }

  // ==================== DELETE ACCOUNT ====================
  static Future<void> deleteUser(String id) async {
    final box = Hive.box<User>(userBoxName);
    await box.delete(id);
  }

  // ==================== UTILITY ====================
  static Future<List<User>> getAllUsers() async {
    final box = Hive.box<User>(userBoxName);
    return box.values.toList();
  }

  static Future<void> clearAllUsers() async {
    final box = Hive.box<User>(userBoxName);
    await box.clear();
  }
}