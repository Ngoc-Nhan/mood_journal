import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mood_journal/db/database_helper.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/providers/settings_provider.dart';
import 'package:mood_journal/providers/theme_provider.dart';
import 'package:mood_journal/repository/note_repository.dart';
import 'package:mood_journal/screens/home/home_screen.dart';
import 'package:mood_journal/services/settings_service.dart';
import 'package:mood_journal/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  // Đảm bảo Flutter đã được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await DatabaseHelper.instance.database;

  // Khởi tạo service
  final settingsService = SettingsService();
  // Kiểm tra xem PIN có tồn tại không
  final bool hasPin = await settingsService.hasPin();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(MyApp(hasPin: hasPin));
}

class MyApp extends StatelessWidget {
  final bool hasPin;
  const MyApp({super.key, required this.hasPin});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (_) => NoteProvider(repository: NoteRepository()),
        ),
        // ChangeNotifierProvider(create: (_) => EditorProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Mood Journal',

            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
            // Quyết định màn hình đầu tiên dựa trên việc có PIN hay không
            // home: hasPin ? const PinLoginPage() : const SetupPage(),
          );
        },
      ),
    );
  }
}
