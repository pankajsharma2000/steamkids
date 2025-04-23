import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define a model for User
class User {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String skills; // New field for skills
  final String interests; // New field for interests
  final String role; // New field for role (e.g., Student, Mentor, Parent)
  final String youtube; // New field for YouTube URL
  final int rating; // Add this field to the User model

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.skills,
    required this.interests,
    required this.role,
    required this.youtube,
    required this.rating, // Add this field
  });

  // Factory method to create a User from Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      skills: data['skills'] ?? '', // Map skills field
      interests: data['interests'] ?? '', // Map interests field
      role: data['role'] ?? '', // Map role field
      youtube: data['youtube'] ?? '', // Map YouTube URL field
      rating: data['rating'] ?? 0, // Map the rating field
    );
  }
}

// Define a provider to fetch users from Firestore
final userProvider = StreamProvider<List<User>>((ref) {
  return FirebaseFirestore.instance.collection('users').snapshots().map(
    (snapshot) {
      return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
    },
  );
});