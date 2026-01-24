import 'package:flutter/material.dart';
import 'package:mood_journal/components/onboarding/onboarding_layout.dart';
import 'package:mood_journal/services/settings_service.dart';
import 'choice_theme.dart';

class InputInfo extends StatefulWidget {
  const InputInfo({super.key});

  @override
  State<InputInfo> createState() => _InputInfoState();
}

class _InputInfoState extends State<InputInfo> {
  late final TextEditingController _nameController;
  final _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onNext(BuildContext context) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    await _settingsService.saveUserName(name);

    Navigator.push(context, MaterialPageRoute(builder: (_) => ChoiceTheme()));
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      title: 'Your Personalized Wellness Journey Starts Here',
      titleStyle: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),

      subtitle: 'Let us know your name',
      primaryText: "Next",
      onPrimary: () => _onNext(context),
      body: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          hintText: 'Enter your name',
          border: OutlineInputBorder(),
        ),
      ),

      // body: SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.all(32),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         const SizedBox(height: 40),

      //         Text(
      //           '',
      //           style: Theme.of(context).textTheme.headlineLarge?.copyWith(
      //             fontSize: 50,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),

      //         const SizedBox(height: 30),

      //         Text(
      //           'Let us know your name',
      //           style: Theme.of(context).textTheme.titleLarge,
      //         ),

      //         const SizedBox(height: 34),

      //         TextField(
      //           controller: _nameController,
      //           decoration: const InputDecoration(
      //             hintText: 'Enter your name',
      //             border: OutlineInputBorder(),
      //           ),
      //         ),

      //         const Spacer(),

      //         SizedBox(
      //           width: double.infinity,
      //           height: 50,
      //           child: ElevatedButton(
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: Colors.pink.shade200,
      //               foregroundColor: Colors.white,
      //             ),
      //             onPressed: () => _onNext(context),
      //             child: const Text(
      //               'Next',
      //               style: TextStyle(fontSize: 18, color: Colors.white),
      //             ),
      //           ),
      //         ),
      //         const SizedBox(height: 26),
      //       ],
      //     ),
      //   ),
    );
  }
}
