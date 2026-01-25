import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mood_journal/components/onboarding/start_screen.dart';
// import 'package:mood_journal/components/onboarding/start_screen.dart';
import 'package:mood_journal/db/database_helper.dart';
import 'package:mood_journal/pages/pin_login_page.dart';
// import 'package:mood_journal/pages/setup_page.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/providers/settings_provider.dart';
import 'package:mood_journal/providers/theme_provider.dart';
import 'package:mood_journal/repository/note_repository.dart';
import 'package:mood_journal/screens/home/home_screen.dart';
// import 'package:mood_journal/services/notifications_service.dart';
// import 'package:mood_journal/screens/home/home_screen.dart';
import 'package:mood_journal/services/settings_service.dart';
import 'package:mood_journal/theme/app_theme.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mood_journal/services/ai_respone.dart';

void main() async {
  // Đảm bảo Flutter đã được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await DatabaseHelper.instance.database;
  // final prefs = await SharedPreferences.getInstance();

  // // Mặc định là true nếu chưa từng lưu giá trị này (lần đầu cài app)
  // final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;
  // Khởi tạo service
  // đọc tên khi mở app
  final settingsService = SettingsService();
  final bool hasName = await settingsService.hasUserName();
  // final settings = SettingsService();
  final bool isFirstTime = await settingsService.isFirstTime();
  // Kiểm tra xem PIN có tồn tại không
  final bool hasPin = await settingsService.hasPin();
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  // khởi tạo notification thông báo hằng ngày
  // await NotificationService().init();

  final themeProvider = ThemeProvider();
  await themeProvider.loadBackground();
  runApp(
    MyApp(
      showOnboarding: isFirstTime,
      hasPin: hasPin,
      themeProvider: themeProvider,
      hasName: hasName,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  final bool hasPin;
  final ThemeProvider themeProvider;
  final bool hasName;

  const MyApp({
    super.key,
    required this.showOnboarding,
    required this.hasPin,
    required this.themeProvider,
    required this.hasName,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeminiService()),

        // ChangeNotifireProvider(
        //   create : (_)=> SettingsProvider()..loadUserName(),
        // )
        // ChangeNotifierProvider.value(value: themeProvider),
        // ChangeNotifierProvider(create: (_) => SettingsProvider()),
        // ChangeNotifierProvider(
        //   create: (_) => NoteProvider(repository: NoteRepository()),
        // ),
        // ChangeNotifierProvider(create: (_) => EditorProvider()),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()
            ..loadUserName()
            ..updateStreakOnAppActive(),
        ),

        ChangeNotifierProvider.value(value: themeProvider),

        ChangeNotifierProvider(
          create: (_) => NoteProvider(repository: NoteRepository()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Mood Journal',

            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            // home:
            // Quyết định màn hình đầu tiên dựa trên việc có ten dang nhap  hay chua không
            home: _getStartPage(),
          );
        },
      ),
    );
  }

  Widget _getStartPage() {
    if (!hasName) return const WelcomeScreen();
    if (hasPin) return const PinLoginPage();
    return const HomeScreen();
  }
}
