import 'package:flutter/material.dart';
import 'package:mood_journal/screens/home/home_screen.dart';
import '../../components/bottom_nav_layout.dart';

class InputInfo extends StatelessWidget {
  InputInfo({super.key});

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Trang thứ hai')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),

            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  'Your Personalized Wellness Journey Starts Here',
                  style: TextStyle(fontSize: 44),
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Let us know your name',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Enter Your Name',
                  ),
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isEmpty) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
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
                    child: const Text('Next', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
