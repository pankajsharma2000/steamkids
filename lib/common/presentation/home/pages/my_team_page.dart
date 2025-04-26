import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTeamPage extends StatelessWidget {
  const MyTeamPage({super.key});

  Future<Map<String, dynamic>?> _fetchUserTeam() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null; // User is not logged in
    }

    final userId = user.uid;

    // Query the teams collection to find the team containing the logged-in user
    final teamsSnapshot = await FirebaseFirestore.instance.collection('teams').get();

    for (final teamDoc in teamsSnapshot.docs) {
      // Check if the logged-in user's ID exists as a document ID in the users subcollection
      final userDoc = await teamDoc.reference.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return teamDoc.data(); // Return the team data
      }
    }

    return null; // No team found for the logged-in user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Team')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserTeam(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('You are not part of any team.'),
            );
          }

          final teamData = snapshot.data!;
          final teamName = teamData['name'] ?? 'Unknown Team';
          final teamDescription = teamData['description'] ?? 'No description available.';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  teamDescription,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}