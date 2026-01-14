import 'package:flutter/material.dart';
import 'package:mood_journal/components/onboarding/onboarding_layout.dart';
import '../../screens/home/home_screen.dart';
import '../bottom_nav_layout.dart';

// class CardScreen extends StatelessWidget{
//   const CardScreen
// }

class WelcomePage extends StatefulWidget {
  final String name;
  const WelcomePage({super.key, required this.name});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      title: 'Welcom to \nTHE SANCTUARY',
      subtitle: '',
      body: const CardScreen(),
      primaryText: 'Okay !',
      onPrimary: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BottomNavLayout(name: widget.name)),
        );
      },
    );
  }
}

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
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
  CardItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pinkAccent),
        borderRadius: BorderRadius.circular(6),
      ),

      margin: EdgeInsets.only(bottom: 22),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );

    // TODO: implement build
  }
}
