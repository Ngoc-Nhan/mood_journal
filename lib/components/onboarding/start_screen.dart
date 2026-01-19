import 'package:flutter/material.dart';
import 'input_name.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _startJourney(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InputInfo()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ====== HÌNH + CHỮ ======
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/welcome_1.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),

                  Positioned(
                    top: 100,
                    child: Column(
                      children: [
                        Text(
                          'THE INNER',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w300,
                                letterSpacing: 2,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'SANCTUARY',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: const Color(0xFFD9A5A5),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ====== BUTTON + NOTE ======
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _startJourney(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade200,
                      ),
                      child: const Text(
                        'Start your Journey',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'I accept terms and conditions, when I proceed.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  //  / const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
