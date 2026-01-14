import 'package:flutter/material.dart';
import 'package:mood_journal/screens/home/home_screen.dart';
import 'package:mood_journal/screens/welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // 'this' refers to the SingleTickerProviderStateMixin
      duration: const Duration(seconds: 2), // Duration of the animation
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward(); // Start the animation
    _initializeApp();
    // You might want to navigate to the next screen after the animation completes
    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     // Navigate to home screen or login screen
    //   }
    // });
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Important: dispose the controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const SizedBox(height: 20),

              //
              Expanded(
                flex: 5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // ====== ẢNH NỀN ======
                    Image.asset(
                      'assets/images/welcome.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),

                    // ====== CHỮ NẰM TRONG HÌNH ======
                    Positioned(
                      top: 200, //  chỉnh cao thấp chữ
                      child: Column(
                        children: [
                          Text(
                            'THE INNER',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'SANCTUARY',
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD9A5A5),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Note mood save your day!',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Color(0xFFD9A5A5)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tiêu đề và mô tả
              // Column(
              //   children: const [
              //     Text(
              //       'Emotional Journal',
              //       style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              //     ),
              //
              //     Text(
              //       'A safe place to write your feelings every day.',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(fontSize: 16, color: Colors.grey),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 24),
            ],
          ), // Replace with your app logo
        ),
      ),
    );
  }
}
