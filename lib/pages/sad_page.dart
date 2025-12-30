import 'package:flutter/material.dart';

class SadPage extends StatefulWidget {
  const SadPage({super.key});

  @override
  State<SadPage> createState() => _SadPagedState();
}

class _SadPagedState extends State<SadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Chào bạn nha')),
    );
  }
}
