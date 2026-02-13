import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// 💡 Menarik! Menggunakan file system (`path_provider`) untuk menyimpan preferensi tema. 
// Alternatif yang solid selain `shared_preferences` untuk data sederhana. 📂✨
// 💎 Menarik! Menggunakan file system (`path_provider`) untuk menyimpan preferensi tema. 
// Alternatif yang solid selain `shared_preferences` untuk data sederhana. 📂✨
class ThemeStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/theme_preference.txt');
  }

  static Future<String> readTheme() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        return contents;
      }
      return 'light'; // Default value
    } catch (e) {
      print('Error reading theme: $e');
      return 'light';
    }
  }

  static Future<void> writeTheme(String theme) async {
    try {
      final file = await _localFile;
      await file.writeAsString(theme);
      print('Theme saved successfully: $theme');
    } catch (e) {
      print('Error writing theme: $e');
    }
  }
}