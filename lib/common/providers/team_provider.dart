import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define a model for Team
class Team {
  final String id;
  final String name;
  final String description;

  Team({
    required this.id,
    required this.name,
    required this.description,
  });

  // Factory method to create a Team from Firestore document
  factory Team.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Team(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }
}

// Define a provider to fetch teams from Firestore
final teamProvider = StreamProvider<List<Team>>((ref) {
  return FirebaseFirestore.instance.collection('teams').snapshots().map(
    (snapshot) {
      return snapshot.docs.map((doc) => Team.fromFirestore(doc)).toList();
    },
  );
});