import 'package:flutter/material.dart';
import 'package:mood_journal/components/onboarding/onboarding_layout.dart';
import 'onboarding_layout.dart';
import './welcome_page.dart';

class PinPage extends StatefulWidget {
  final String name;
  const PinPage({super.key, required this.name});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  // final TextEditingController _pinController = TextEditingController();
  List<int> pin = [];
  static const int pinLength = 4;
  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinLength, (index) {
        final filled = index < pin.length;
        return Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 10),
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
      child: Center(
        child: Text(number.toString(), style: const TextStyle(fontSize: 22)),
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
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
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
    return OnboardingLayout(
      title: 'Password (PIN)',
      subtitle: 'Let enter password to protect your note',
      // body: const Text('Nhập PIN'),
      body: Column(
        children: [
          const SizedBox(height: 30),
          _buildPinDots(),
          const SizedBox(height: 50),
          _buildKeypad(),
        ],
      ),
      // PinInput(controller: _pinController),
      primaryText: 'Next',
      onPrimary: pin.length == pinLength
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WelcomePage(name: widget.name),
                ),
              );
            }
          : null,
      // if (pin.length == 4) {
      //   //todo : lưu pin
      //   print('PIN =$pin');
      // }
      secondaryButton: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WelcomePage(name: widget.name),
                ),
              );
            },
            child: Text('Skip', style: TextStyle(color: Colors.black)),
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
