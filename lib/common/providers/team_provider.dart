import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define a model for Team
class Team {
  final String id;
  final String name;
  final String description;
  final List<String> userNames; // List of user names in the team

  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.userNames,
  });

  // Factory method to create a Team from Firestore document
  static Future<Team> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final teamId = doc.id;

    // Fetch the subcollection of users for this team
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .collection('users')
        .get();

    // Fetch user names from the main users collection
    final userNames = await Future.wait<String>(usersSnapshot.docs.map((userDoc) async {
      final userId = userDoc.id;
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        return userData['name'] ?? 'Unknown User';
      }
      return 'Unknown User';
    }));

    return Team(
      id: teamId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      userNames: userNames,
    );
  }
}

// Define a provider to fetch teams and their users from Firestore
final teamProvider = StreamProvider<List<Team>>((ref) async* {
  final teamSnapshots = FirebaseFirestore.instance.collection('teams').snapshots();

  await for (final snapshot in teamSnapshots) {
    final teams = await Future.wait(snapshot.docs.map((doc) => Team.fromFirestore(doc)));
    yield teams;
  }
});