import 'package:flutter/material.dart';

class ExcitedPage extends StatefulWidget {
  const ExcitedPage({super.key});

  @override
  State<ExcitedPage> createState() => _ExcitedPgeState();
}

class _ExcitedPgeState extends State<ExcitedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Chào bạn nha'),
      ),
    );
  }
}
