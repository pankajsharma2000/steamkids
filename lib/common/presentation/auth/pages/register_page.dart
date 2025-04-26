import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _selectedRole = 'Student'; // Default role

  Future<void> _registerWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String name = _nameController.text.trim();
      final String interests = _interestsController.text.trim();
      final String skills = _skillsController.text.trim();
      final String youtube = _youtubeController.text.trim();

      if (email.isEmpty || password.isEmpty || name.isEmpty || _selectedRole.isEmpty) {
        debugPrint('All fields are required');
        return;
      }

      // Register with email and password
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user details to Firestore
      final userId = userCredential.user?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'name': name,
          'email': email,
          'interests': interests,
          'skills': skills,
          'youtube': youtube,
          'role': _selectedRole,
        });
      }

      debugPrint('User registered successfully');
      // Navigate back to LoginPage after successful registration
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error during registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: _interestsController,
                decoration: const InputDecoration(labelText: 'Interests'),
              ),
              TextField(
                controller: _skillsController,
                decoration: const InputDecoration(labelText: 'Skills'),
              ),
              TextField(
                controller: _youtubeController,
                decoration: const InputDecoration(labelText: 'YouTube Channel'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(value: 'Student', child: Text('Student')),
                  DropdownMenuItem(value: 'Mentor', child: Text('Mentor')),
                  DropdownMenuItem(value: 'Parent', child: Text('Parent')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _registerWithEmailAndPassword,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}