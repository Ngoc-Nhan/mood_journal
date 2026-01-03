import 'package:flutter/material.dart';
import '../../models/mood_selector.dart';
import 'package:typewritertext/typewritertext.dart';
import '../../models/choice_plan.dart';

String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning!';
  } else if (hour < 18) {
    return 'Good Afternoon!';
  } else {
    return 'Good Evening!';
  }
}

class HomeScreen extends StatelessWidget {
  final String name;

  // ✅ name KHÔNG còn required nữa
  const HomeScreen({
    super.key,
    this.name = 'User', // giá trị mặc định
  });

  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  width: double.infinity,
                  height: 160, // 🔽 giảm từ 180 → 160
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 60, // 🔽 giảm nhẹ
                left: 20,
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/welcome.png',
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getGreeting(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          'Hello, $name',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 30),

                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.grey.shade800,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 140,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/wave.png',
                    fit: BoxFit.cover,
                    height: 70, // 🔽 giảm
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const MoodSelector(),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TypeWriter.text(
              'How are you feeling today?',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              duration: const Duration(milliseconds: 50),
            ),
          ),

          const SizedBox(height: 16),

          const ChoiceOption(),

          const SizedBox(height: 24), // tránh sát đáy
        ],
      ),
    );
  }
}
