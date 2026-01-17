import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mood_journal/app.dart';
// import 'screens/welcome/welcome_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/bottom_navi/insights_screen.dart';


void main() {
  runApp(
    DevicePreview(
      // Enable preview only in non-release mode
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: Layout(),
    );
  }
}
