import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define a model for Club
class Club {
  final String id;
  final String name;
  final String description;
  final List<String> userNames; // List of user names in the club

  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.userNames,
  });

  // Factory method to create a Club from Firestore document
  static Future<Club> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final clubId = doc.id;

    // Fetch the subcollection of users for this club
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
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

    return Club(
      id: clubId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      userNames: userNames,
    );
  }
}

// Define a provider to fetch clubs and their users from Firestore
final clubProvider = StreamProvider<List<Club>>((ref) async* {
  final clubSnapshots = FirebaseFirestore.instance.collection('clubs').snapshots();

  await for (final snapshot in clubSnapshots) {
    final clubs = await Future.wait(snapshot.docs.map((doc) => Club.fromFirestore(doc)));
    yield clubs;
  }
});