import 'package:flutter/material.dart';

class MyTeamPage extends StatelessWidget {
  const MyTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Team')),
      body: const Center(
        child: Text('Welcome to My Team!'),
      ),
    );
  }
}