import 'package:flutter/material.dart';
import '../pages/angry_page.dart';
import '../pages/excited_pge.dart';
import '../pages/happy_page.dart';
import '../pages/nervous_page.dart';
import '../pages/sad_page.dart';

// dinh nghia model Mood de luu tru thong tin ve tam trang cua nguoi dung
class Mood {
  final String id;
  final String label;
  final String imagePath; // assets/images/happy.png
  final double offsetY;
  final Widget page;

  const Mood({
    required this.id,
    required this.label,
    required this.imagePath,
    this.offsetY = 0.0,
    required this.page,
  });
}

// du lieu mood

const moods = [
  Mood(
    id: 'sad',
    label: 'Sad',
    imagePath: 'assets/images/sad.png',
    offsetY: -4,
    page: SadPage(),
  ),
  Mood(
    id: 'angry',
    label: 'Angry',
    imagePath: 'assets/images/angry.png',
    page: AngryPage(),
  ),
  Mood(
    id: 'excited',
    label: 'Excited',
    imagePath: 'assets/images/excited.png',
    offsetY: -4,
    page: ExcitedPage(),
  ),
  Mood(
    id: 'nervous',
    label: 'Nervous',
    imagePath: 'assets/images/nervous.png',
    page: NervousPage(),
  ),
  Mood(
    id: 'happy',
    label: 'Happy',
    imagePath: 'assets/images/happy.png',
    offsetY: -4,
    page: HappyPage(),
  ),
];

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: moods.asMap().entries.map((entry) {
          final mood = entry.value;
          final index = entry.key;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => mood.page),
              );
            },

            child: Transform.translate(
              offset: Offset(0, index.isEven ? -4 : 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    // radius: 22,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      mood.imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(mood.label, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
