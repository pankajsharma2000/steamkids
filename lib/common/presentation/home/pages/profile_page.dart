import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedRole = 'Student'; // Default role
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle unauthenticated user
      return;
    }

    _userId = user.uid;

    // Fetch user data from Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(_userId).get();

    if (userDoc.exists) {
      final userData = userDoc.data();
      setState(() {
        _nameController.text = userData?['name'] ?? '';
        _interestsController.text = userData?['interests'] ?? '';
        _skillsController.text = userData?['skills'] ?? '';
        _locationController.text = userData?['location'] ?? '';
        _youtubeController.text = userData?['youtube'] ?? '';
        _emailController.text = userData?['email'] ?? '';
        _selectedRole = userData?['role'] ?? 'Student';
      });
    }
  }

  Future<void> _saveUserData() async {
    if (_userId == null) return;

    try {
      // Update user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(_userId).update({
        'name': _nameController.text.trim(),
        'interests': _interestsController.text.trim(),
        'skills': _skillsController.text.trim(),
        'youtube': _youtubeController.text.trim(),
        'role': _selectedRole,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Name Field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Interests Field
            TextField(
              controller: _interestsController,
              decoration: const InputDecoration(
                labelText: 'Interests',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Skills Field
            TextField(
              controller: _skillsController,
              decoration: const InputDecoration(
                labelText: 'Skills',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Location Field (Read-Only)
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Make the location field read-only
            ),
            const SizedBox(height: 16),
            // YouTube URL Field
            TextField(
              controller: _youtubeController,
              decoration: const InputDecoration(
                labelText: 'YouTube URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Role Dropdown
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
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
            ),
            const SizedBox(height: 16),
            // Save Button
            ElevatedButton(
              onPressed: _saveUserData,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> uploadUserPicture(String userId, File imageFile) async {
  try {
    // Upload the image to Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/$userId.jpg');
    final uploadTask = await storageRef.putFile(imageFile);

    // Get the download URL
    final photoUrl = await storageRef.getDownloadURL();

    // Save the URL in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'photoUrl': photoUrl,
    });

    print('Profile picture uploaded and URL saved in Firestore.');
  } catch (e) {
    print('Error uploading profile picture: $e');
  }
}