import 'package:flutter/material.dart';
import 'package:mood_journal/components/onboarding/onboarding_layout.dart';
import 'package:mood_journal/services/settings_service.dart';
// import 'onboarding_layout.dart';
import './welcome_page.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  // final TextEditingController _pinController = TextEditingController();
  final _settingsService = SettingsService();
  List<int> pin = [];
  static const int pinLength = 4;

  void _saveSettings() async {
    // if (pin.length < pinLength) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Vui lòng nhập đầy đủ tên và mã PIN.')),
    //   );
    //   return;
    // }

    await _settingsService.savePin(pin.join());
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinLength, (index) {
        final filled = index < pin.length;
        return Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? Colors.pink : Colors.transparent,
            border: Border.all(color: Colors.pink),
          ),
        );
      }),
    );
  }

  Widget _buildNumberButton(int number) {
    return GestureDetector(
      onTap: () {
        if (pin.length < pinLength) {
          setState(() => pin.add(number));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          border: Border.all(color: Colors.pink),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Text(number.toString(), style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: () {
        if (pin.isNotEmpty) {
          setState(() => pin.removeLast());
        }
      },
      child: const Icon(Icons.backspace_outlined),
    );
  }

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 20,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (int i = 1; i <= 9; i++) _buildNumberButton(i),
          const SizedBox(), // ô trống (X)
          _buildNumberButton(0),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OnboardingLayout(
      title: 'Password (PIN)',
      subtitle: 'Let enter password to protect your note',
      // body: const Text('Nhập PIN'),
      body: Column(
        children: [
          // const SizedBox(height: ),
          _buildPinDots(),
          const SizedBox(height: 30),
          _buildKeypad(),
        ],
      ),
      // PinInput(controller: _pinController),
      primaryText: 'Next',
      onPrimary: pin.length == pinLength
          ? () {
              _saveSettings();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WelcomePage()),
              );
            }
          : null,
      secondaryButton: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WelcomePage()),
              );
            },
            child: Text(
              'Skip',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

// class PinInput extends StatelessWidget {
//   final TextEditingController controller;
//   const PinInput({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: 220,
//         child: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           obscureText: true,
//           maxLength: 4,
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 28, letterSpacing: 16),
//           decoration: const InputDecoration(
//             counterText: '',
//             hintText: '••••',
//             border: UnderlineInputBorder(),
//           ),
//         ),
//       ),
//     );
//   }
// }
