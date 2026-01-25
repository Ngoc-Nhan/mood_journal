import 'package:flutter/material.dart';
import 'package:mood_journal/components/onboarding/onboarding_layout.dart';
import 'package:mood_journal/screens/home/home_screen.dart';
import 'package:mood_journal/services/settings_service.dart';

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  // final _pinController = TextEditingController();
  final _settingsService = SettingsService();
  String? _errorText;
  static const int pinLength = 4;
  final List<int> pin = [];

  void _unlockApp() async {
    final savedPin = await _settingsService.getPin();
    final enteredPin = pin.join();
    if (savedPin == enteredPin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _errorText = 'Mã PIN không đúng. Vui lòng thử lại.';
        pin.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      title: 'Nhập Mã PIN',
      subtitle: 'Vui lòng nhập mã PIN của bạn để mở khóa.',
      subtitleStyle: const TextStyle(fontSize: 18),
      onPrimary: pin.length == pinLength ? () => _unlockApp() : null,
      primaryText: 'Mở khóa',
      body: Column(
        // child: SingleChildScrollView(
        // padding: const EdgeInsets.all(24.0),
        // child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPinDots(),
          const SizedBox(height: 30),
          _buildKeypad(),
          // Text(
          //   'Nhập mã PIN của bạn',
          //   textAlign: TextAlign.center,
          //   style: Theme.of(context).textTheme.headlineSmall,
          // ),
          // const SizedBox(height: 24),
          // TextField(
          //   controller: _pinController,
          //   keyboardType: TextInputType.number,
          //   obscureText: true,
          //   textAlign: TextAlign.center,
          //   style: const TextStyle(fontSize: 24, letterSpacing: 16),
          //   decoration: InputDecoration(
          //     labelText: 'Mã PIN',
          //     errorText: _errorText,
          //     border: const OutlineInputBorder(),
          //   ),
          //   onChanged: (value) {
          //     if (_errorText != null) {
          //       setState(() {
          //         _errorText = null;
          //       });
          //     }
          //   },
          // ),
          // const SizedBox(height: 32),
          // ElevatedButton(
          //   onPressed: _unlockApp,
          //   style: ElevatedButton.styleFrom(
          //     padding: const EdgeInsets.symmetric(vertical: 16),
          //   ),
          //   child: const Text('Mở khóa'),
          // ),
        ],
      ),
    );
  }

  Widget _buildPinDots() {
    return Column(
      children: [
        Row(
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
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 12),
          Text(
            _errorText!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent, fontSize: 14),
          ),
        ],
      ],
    );
  }

  Widget _buildNumberButton(int number) {
    return GestureDetector(
      onTap: () {
        if (pin.length < pinLength) {
          setState(() {
            if (_errorText != null) _errorText = null;
            pin.add(number);
          });
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
}
