import 'package:flutter/material.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      body: const Center(
        child: Text('Welcome to Sessions!'),
      ),
    );
  }
}