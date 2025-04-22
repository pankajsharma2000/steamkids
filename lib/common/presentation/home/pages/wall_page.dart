import 'package:flutter/material.dart';

class WallPage extends StatelessWidget {
  const WallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wall')),
      body: const Center(
        child: Text('Welcome to Wall!'),
      ),
    );
  }
}