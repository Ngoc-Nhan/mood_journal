import 'package:typewritertext/typewritertext.dart';
import 'package:flutter/material.dart';
import '../../models/mood_selector.dart';

import '../../models/choice_plan.dart';

import '../../widgets/common_header.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CommonHeader(name: name),

            // Transform.translate(
            //   offset: const Offset(0, -19),
            //   child: const MoodSelector(),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 40),
            //   // co lại khi thiếu chỗ fittedbox
            //   child: FittedBox(
            //     fit: BoxFit.scaleDown,
            //     alignment: Alignment.centerLeft,
            //     child: TypeWriter.text(
            //       'How are you feeling today??',
            //       maxLines: 1,
            //       style: const TextStyle(
            //         fontSize: 18,
            //         fontWeight: FontWeight.w600,
            //       ),
            //       duration: const Duration(milliseconds: 50),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 12),

            // const ChoiceOption(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
