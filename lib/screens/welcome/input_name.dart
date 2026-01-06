import 'package:flutter/material.dart';
import '../../components/bottom_nav_layout.dart';

class InputInfo extends StatelessWidget {
  InputInfo({super.key});

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(38),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text(
              'Your Personalized Wellness Journey Starts Here',
              style: TextStyle(fontSize: 44),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Let us know your name',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(height: 140),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => BottomNavLayout(userName: name,)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade200,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Next', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
