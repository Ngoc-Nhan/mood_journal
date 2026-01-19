import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/bottom_navi/account_screen.dart';
import '../screens/bottom_navi/explore_screen.dart';
import '../screens/bottom_navi/insights_screen.dart';
import '../screens/bottom_navi/sound_screen.dart';

class BottomNavLayout extends StatefulWidget {
  final String name;

  const BottomNavLayout({super.key, required this.name});

  @override
  State<BottomNavLayout> createState() => _BottomNavLayoutState();
}

class _BottomNavLayoutState extends State<BottomNavLayout> {
  int _currentIndex = 0;
  late final List<Widget> pages;

  final Color activeColor = const Color(0xFFF8B4B4);
  final Color inactiveColor = Colors.black54;

  @override
  void initState() {
    super.initState();
    pages = [
      HomeScreen(),
      const ExploreScreen(),
      const SoundScreen(),
      const InsightsScreen(),
      AccountScreen(name: widget.name),
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
        type: BottomNavigationBarType.shifting,
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
