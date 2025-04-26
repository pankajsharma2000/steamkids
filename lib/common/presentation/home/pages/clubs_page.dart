import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamkids/common/providers/club_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClubsPage extends ConsumerStatefulWidget {
  const ClubsPage({super.key});

  @override
  ConsumerState<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends ConsumerState<ClubsPage> {
  String _searchQuery = '';

  Future<void> _joinClub(String clubId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to join a club.')),
      );
      return;
    }

    try {
      // Add the user to the club's users subcollection
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubId)
          .collection('users')
          .doc(user.uid)
          .set({
        'userId': user.uid,
        'email': user.email,
        'name': user.displayName ?? 'Anonymous',
      });

      // Optionally, update the user's document to store the clubId
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'clubId': clubId});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully joined the club!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error joining club: $e')),
      );
    }
  }

  Future<bool> _isUserInClub(String clubId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    final userDoc = await FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .collection('users')
        .doc(user.uid)
        .get();

    return userDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    final clubStream = ref.watch(clubProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clubs'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search clubs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: clubStream.when(
        data: (clubs) {
          // Filter clubs based on the search query
          final filteredClubs = clubs.where((club) {
            return club.name.toLowerCase().contains(_searchQuery) ||
                club.description.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredClubs.isEmpty) {
            return const Center(child: Text('No clubs found.'));
          }

          return ListView.builder(
            itemCount: filteredClubs.length,
            itemBuilder: (context, index) {
              final club = filteredClubs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    club.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(club.description),
                  children: [
                    ...club.userNames.map((userName) {
                      return ListTile(
                        title: Text(userName),
                        leading: const Icon(Icons.person),
                      );
                    }).toList(),
                    FutureBuilder<bool>(
                      future: _isUserInClub(club.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.data == true) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'You are already a member of this club.',
                              style: TextStyle(color: Colors.green),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => _joinClub(club.id), // Pass the club ID
                            child: const Text('Join'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}