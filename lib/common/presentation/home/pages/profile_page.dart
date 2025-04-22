import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // UserId Field
            TextField(
              decoration: const InputDecoration(
                labelText: 'UserId',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Interests Field
            TextField(
              decoration: const InputDecoration(
                labelText: 'Interests',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Skills Field
            TextField(
              decoration: const InputDecoration(
                labelText: 'Skills',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Location Field
            TextField(
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // YouTube URL Field
            TextField(
              decoration: const InputDecoration(
                labelText: 'YouTube URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Role Dropdown
            DropdownButtonFormField<String>(
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
                // Handle role selection
              },
            ),
            const SizedBox(height: 16),
            // Save Button
            ElevatedButton(
              onPressed: () {
                // Handle save action
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}