// import 'package:flutter/material.dart';
// import 'package:mood_journal/screens/home/home_screen.dart';

// class Layout extends StatefulWidget {
//   const Layout({super.key});
//   @override
//   State<Layout> createState() => _App();
// }

// class _App extends State<Layout> {
//   int _selectedIndex = 0;

//   void _navigateBottom(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   final List<Widget> _pages = [
//     HomeScreen(name: 'Van Huynh'),
//     Container(child: Text('Explore')),
//     Container(child: Text('Sound')),
//     Container(child: Text('Insight')),
//     Container(child: Text('Account')),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(child: _pages[_selectedIndex]),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         onTap: _navigateBottom,
//         currentIndex: _selectedIndex,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
//           BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: 'Sound'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.insights),
//             label: 'Insights',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person_2), label: 'Account'),
//         ],
//       ),
//     );
//   }
// }
