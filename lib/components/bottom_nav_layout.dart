import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/bottom_navi/account_screen.dart';
import '../screens/bottom_navi/explore_screen.dart';
import '../screens/bottom_navi/insights_screen.dart';
import '../screens/bottom_navi/sound_screen.dart';

class BottomNavLayout extends StatefulWidget {
  const BottomNavLayout({super.key});

  @override
  State<BottomNavLayout> createState() => _BottomNavLayoutState();
}

class _BottomNavLayoutState extends State<BottomNavLayout> {
  int _currentIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(name: "User"),
    ExploreScreen(),
    SoundScreen(),
    InsightsScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: 'Sound'),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats),
            label: 'Insights',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
