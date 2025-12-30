import 'package:flutter/material.dart';

class HappyPage extends StatefulWidget {
  const HappyPage({super.key});

  @override
  State<HappyPage> createState() => _HappPageState();
}

class _HappPageState extends State<HappyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Chào bạn nha')),
    );
  }
}
