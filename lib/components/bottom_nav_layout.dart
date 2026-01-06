import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/bottom_navi/account_screen.dart';
import '../screens/bottom_navi/explore_screen.dart';
import '../screens/bottom_navi/insights_screen.dart';
import '../screens/bottom_navi/sound_screen.dart';

class BottomNavLayout extends StatefulWidget {
  final String userName;

  const BottomNavLayout({super.key, required this.userName});

  @override
  State<BottomNavLayout> createState() => _BottomNavLayoutState();
}

class _BottomNavLayoutState extends State<BottomNavLayout> {
  int _currentIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomeScreen(name: widget.userName),
      const ExploreScreen(),
      const SoundScreen(),
      const InsightsScreen(),
      AccountScreen(name: widget.userName),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
