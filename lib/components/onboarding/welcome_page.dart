import 'package:flutter/material.dart';
import 'package:mood_journal/components/onboarding/onboarding_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/home/home_screen.dart';
import 'package:mood_journal/theme/app_colors.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Future<void> _showOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      title: 'Welcom to \nTHE SANCTUARY',
      subtitle: '',
      body: const CardScreen(),
      primaryText: 'Okay !',
      onPrimary: () {
        _showOnboarding();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      },
    );
  }
}

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CardItem(
          title: "Save the moment ",
          subtitle: 'Follow your change',
          imagePath: 'assets/images/card1.png',
        ),
        CardItem(
          title: "AI mental help ",
          subtitle: 'Expert solve your mood',
          imagePath: 'assets/images/card2.png',
        ),
        CardItem(
          title: "Secure note ",
          subtitle: 'Protect your note',
          imagePath: 'assets/images/card3.png',
        ),
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const CardItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Màu nen co the thay doi
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // ===================================

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pinkAccent),
        borderRadius: BorderRadius.circular(15),
        // color: Colors.white
        color: isDark
            ? AppColors.cardDark
            : Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 22),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(2),
            child: Image.asset(
              imagePath,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textLight
                        : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
