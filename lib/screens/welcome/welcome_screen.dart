import 'package:flutter/material.dart';
import '../welcome/input_name.dart';
// import './screens/home/home_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../services/settings_service.dart';
import '../../pages/pin_login_page.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserName();
  }

  Future<void> _checkUserName() async {
    final settingsService = SettingsService();
    final hasName = await settingsService.hasUserName();

    if (!mounted) return;

    if (hasName) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
    if (hasName) {
      final hasPin = await settingsService.hasPin();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => hasPin ? const PinLoginPage() : const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // bottom: false,
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
                    'assets/images/welcome_1.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),

                  // ====== CHỮ NẰM TRONG HÌNH ======
                  Positioned(
                    top: 90, //  chỉnh cao thấp chữ
                    child: Column(
                      children: const [
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

            // Button chuyển trang
            Padding(
              padding: const EdgeInsets.all(24.0),

              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InputInfo()),
                        );

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => const HomeScreen()),
                        // );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade200,
                        foregroundColor: Colors.white,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                      ),
                      child: const Text(
                        'Start your Journey',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    'I accept terms and conditions, when i proceed.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
