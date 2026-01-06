import 'package:flutter/material.dart';
import '../../widgets/common_header.dart';

class AccountScreen extends StatelessWidget {
  final String name;

  const AccountScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CommonHeader(
            name: name,
            showNotification: true, // account thì không cần chuông
          ),

          const SizedBox(height: 40),

          // content account bên dưới
        ],
      ),
    );
  }
}
