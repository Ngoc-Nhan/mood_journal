import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<bool> hasUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_name');
  }

  static Future<void> clearUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
  }
}
