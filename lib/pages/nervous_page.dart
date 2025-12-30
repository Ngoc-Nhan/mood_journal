import 'package:flutter/material.dart';

class NervousPage extends StatefulWidget {
  const NervousPage({super.key});

  @override
  State<NervousPage> createState() => _NervousPageState();
}

class _NervousPageState extends State<NervousPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Chào bạn nha')),
    );
  }
}
