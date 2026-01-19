import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  final String name;

  const AccountScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Xin chào'),

          const SizedBox(height: 40),

          // content account bên dưới
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _card([
                    _item('Your name'),
                    _item('Password (Pin)'),
                    _item('Theme'),
                  ]),

                  const SizedBox(height: 24),

                  const Text(
                    'Other',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _card([
                    _item('Share with Friends'),
                    _item('Help'),
                    _item('Rate for app'),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- Widgets helper -----------------

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6EAEA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _item(String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
