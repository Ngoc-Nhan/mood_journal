import 'package:flutter/material.dart';

class AngryPage extends StatefulWidget {
  const AngryPage({super.key});

  @override
  State<AngryPage> createState() => _AngryPageState();
}

class _AngryPageState extends State<AngryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Jello')),
    );
  }
}
