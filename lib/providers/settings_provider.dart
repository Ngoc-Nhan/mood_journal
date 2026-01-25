import 'package:flutter/foundation.dart';
import 'package:mood_journal/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isGridView = true;
  String _sortOrder = 'date_modified';
  // final SettingsService _settingsService = SettingsService();
  String? _userName;
  // bool _isNotificationOn = false;
  // String _reminderTime = "20:00";

  // bool get isNotificationOn => _isNotificationOn;
  // String get reminderTime => _reminderTime;
  String? get userName => _userName;

  bool get isGridView => _isGridView;
  String get sortOrder => _sortOrder;
  //khai báo steak
  int _streak = 0;
  int get streak => _streak;
  List<String> _streakHistory = [];
  List<String> get streakHistory => _streakHistory;

  SettingsProvider() {
    _loadSettings();
  }

  // load khi app start
  // Cập nhật hàm _loadSettings hiện tại của bạn
  // Future<void> _loadSettings() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _isGridView = prefs.getBool('grid_view') ?? false;
  //   _sortOrder = prefs.getString('sort_order') ?? 'date_modified';
  //   _userName = prefs.getString('user_name');
  //   _streak = prefs.getInt('user_streak') ?? 0;

  //   // 👉 Thêm 2 dòng này để load trạng thái thông báo
  //   _isNotificationOn = prefs.getBool('is_notification_on') ?? false;
  //   _reminderTime = prefs.getString('reminder_time') ?? "20:00";

  //   notifyListeners();
  // }

  // // Hàm bật/tắt Switch
  // Future<void> toggleNotification(bool value) async {
  //   _isNotificationOn = value;
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('is_notification_on', value);
  //   notifyListeners();
  // }

  // // Hàm lưu giờ đã chọn
  // Future<void> setReminderTime(String time) async {
  //   _reminderTime = time;
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('reminder_time', time);
  //   notifyListeners();
  // }

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
  Future<void> updateStreakOnAppActive() async {
    final prefs = await SharedPreferences.getInstance();

    _streak = prefs.getInt('user_streak') ?? 0;
    // _streakHistory = prefs.getStringList('streak_history') ?? [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayStr = today.toIso8601String();

    final lastActiveStr = prefs.getString('last_active_date');

    if (lastActiveStr != null) {
      final lastActive = DateTime.parse(lastActiveStr);
      final lastDate = DateTime(
        lastActive.year,
        lastActive.month,
        lastActive.day,
      );

      final diff = today.difference(lastDate).inDays;

      if (diff == 0) return; // mở lại cùng ngày
      if (diff == 1) {
        _streak += 1;
      } else {
        _streak = 1;
        _streakHistory.clear(); // reset chuỗi cũ
      }
    } else {
      _streak = 1;
    }

    // 👉 lưu ngày hôm nay nếu chưa có
    if (!_streakHistory.contains(todayStr)) {
      _streakHistory.add(todayStr);
    }

    await prefs.setInt('user_streak', _streak);
    await prefs.setString('last_active_date', todayStr);
    // await prefs.setStringList('streak_history', _streakHistory);

    notifyListeners();
  }
}
