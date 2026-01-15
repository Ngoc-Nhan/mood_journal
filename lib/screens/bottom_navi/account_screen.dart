import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  final String name;

  const AccountScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text('Xin chào'),

          const SizedBox(height: 40),

          // content account bên dưới
        ],
      ),
    );
  }
}
