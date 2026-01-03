import 'package:flutter/material.dart';

import '../../models/mood_selector.dart';
import 'package:typewritertext/typewritertext.dart';
import '../../models/choice_plan.dart';

String getGreeting() {
  final hour = DateTime.now().hour;
  String greeting;

  if (hour < 12) {
    greeting = 'Good Morning';
  } else if (hour < 18) {
    greeting = 'Good Afternoon';
  } else {
    greeting = 'Good Evening';
  }

  return '$greeting ! ';
}

// Widget iconSection() {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 20),
//     padding: const EdgeInsets.symmetric(vertical: 20),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(24),
//       boxShadow: [
//         BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: const [
//         Icon(Icons.home, size: 30),
//         Icon(Icons.favorite, size: 30),
//         Icon(Icons.person, size: 30),
//       ],
//     ),
//   );
// }

class HomeScreen extends StatelessWidget {
  final String name;
  const HomeScreen({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      // appBar: AppBar(title: const Text('Home Screen')),
      body: Column(
        children: [
          Stack(
            // khong cat phan thua
            clipBehavior: Clip.none,
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 70,
                left: 20,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    //Avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/welcome.png',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lời chào
                        Text(
                          getGreeting(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),

                        // Tên người dùng
                        Text(
                          'Hello, $name', // tên người dùng
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 40),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.grey.shade800,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 160,
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/wave.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    height: 90, // chỉ lấy phần trên
                    width: double.infinity,
                  ),
                ),
              ),
              // Positioned(
              //   top: 193,
              //   left: 20,
              //   right: 20,
              //   child: const MoodSelector(),
              // ),
            ],
          ),

          // SizedBox(height: 100),
          // const SizedBox(height: 100),
          // const MoodSelector(),
          Transform.translate(
            offset: const Offset(0, -18), // 👈 số âm = đẩy lên
            child: const MoodSelector(),
          ),

          Container(
            padding: EdgeInsets.only(left: 60),
            width: double.infinity,

            child: TypeWriter.text(
              'How are you felling today ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              duration: const Duration(milliseconds: 50),
            ),
          ),
          // SizedBox(height: 20),

          // SizedBox(height: 50),
          // const SizedBox(height: 1),

          // MoodSelector(),

          // TypeWriter.text(
          //   'How are you feeling today ?',
          //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          //   duration: const Duration(milliseconds: 50),
          // ),
          ChoiceOption(),
        ],
      ),
    );
  }
}
