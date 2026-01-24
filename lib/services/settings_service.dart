import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Dùng để lưu trữ an toàn
  final _secureStorage = const FlutterSecureStorage();
  // Dùng để lưu trữ thông thường
  // final _prefs = SharedPreferences.getInstance();

  // Các key để lưu trữ
  static const _pinKey = 'user_pin';
  static const _nameKey = 'user_name';
  static const _themeKey = 'user_theme_background';
  static const _isFirstTimeKey = 'is_first_time';
  // --- Quản lý PIN ---

  Future<void> savePin(String pin) async {
    await _secureStorage.write(key: _pinKey, value: pin);
  }

  Future<String?> getPin() async {
    return await _secureStorage.read(key: _pinKey);
  }

  Future<bool> hasPin() async {
    final pin = await getPin();
    return pin != null && pin.isNotEmpty;
  }

  Future<void> deletePin() async {
    await _secureStorage.delete(key: _pinKey);
  }

  // --- Quản lý Tên người dùng ---
  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  Future<bool> hasUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_nameKey);
  }

  // --- Quản lý Theme (Hình nền) ---
  Future<void> saveTheme(String themePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themePath);
  }

  Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Trả về một giá trị mặc định nếu chưa được cài đặt
    return prefs.getString(_themeKey);
  }

  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    // Nếu chưa có giá trị, mặc định trả về true (là lần đầu)
    return prefs.getBool(_isFirstTimeKey) ?? true;
  }

  Future<void> setFirstTimeComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstTimeKey, false);
  }

  // --- Quản lý Streak ---
  Future<void> updateStreakOnAppOpen(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', streak);
  }
  
}
