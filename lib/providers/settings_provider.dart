import 'package:flutter/foundation.dart';
import 'package:mood_journal/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isGridView = true;
  String _sortOrder = 'date_modified';
  // final SettingsService _settingsService = SettingsService();
  String? _userName;
  String? get userName => _userName;

  bool get isGridView => _isGridView;
  String get sortOrder => _sortOrder;
  //khai báo steak
  int _streak = 0;
  int get streak => _streak;

  SettingsProvider() {
    _loadSettings();
  }

  // load khi app start

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isGridView = prefs.getBool('grid_view') ?? false;
    _sortOrder = prefs.getString('sort_order') ?? 'date_modified';
    // Load user name
    // _userName = await _settingsService.getUserName();
    _userName = prefs.getString('user_name');
    _streak = prefs.getInt('user_streak') ?? 0;

    notifyListeners();
  }

  // update ten user
  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name');
    notifyListeners();
  }
  // luu cap nhat

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    _userName = name;
    notifyListeners();
  }

  Future<void> setViewMode(bool isGrid) async {
    _isGridView = isGrid;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('grid_view', isGrid);
  }

  Future<void> setSortOrder(String order) async {
    _sortOrder = order;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sort_order', order);
  }
  //load streak
  Future<void> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    _streak = prefs.getInt('user_streak') ?? 0;
    notifyListeners();
  }

  //update  streak
  Future<void> updateStreakOnAppOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final lastOpen = prefs.getString('last_open_date');
    final today = DateTime.now();
    if (lastOpen != null) {
      final lastDate = DateTime.parse(lastOpen);
      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        // Tăng streak nếu mở app vào ngày tiếp theo
        _streak += 1;
      } else if (difference > 1) {
        // Reset streak nếu bỏ lỡ nhiều ngày
        _streak = 0;
      }
    } else {
      // Lần đầu mở app
      _streak = 1;
    }
    await prefs.setString('last_open_date', today.toIso8601String());
    await prefs.setInt('user_streak', _streak);
  }
}
