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
      HomeScreen(name: widget.name),
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

      /// NÚT +
      floatingActionButton: Container(
        height: 52,
        width: 52,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFF8B4B4),
        ),
        child: IconButton(
          icon: const Icon(Icons.add, size: 26, color: Colors.black),
          onPressed: () {
            setState(() => _currentIndex = 2);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// BOTTOM BAR
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ĐƯỜNG NGANG MỎNG
          Container(height: 1, color: Colors.black12),

          BottomAppBar(
            elevation: 0,
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: 6,
            child: SizedBox(
              height: 38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _tab(Icons.home_outlined, 'Home', 0),
                  _tab(Icons.explore, 'Calendar', 1),

                  const SizedBox(width: 40),

                  _tab(Icons.show_chart_outlined, 'Insights', 3),
                  _tab(Icons.settings_outlined, 'Settings', 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: isActive ? activeColor : inactiveColor),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
