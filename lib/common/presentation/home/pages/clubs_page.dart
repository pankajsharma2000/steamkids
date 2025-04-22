import 'package:flutter/material.dart';

class ClubsPage extends StatelessWidget {
  const ClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clubs')),
      body: const Center(
        child: Text('Welcome to Clubs!'),
      ),
    );
  }
}