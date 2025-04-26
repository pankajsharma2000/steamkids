import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamkids/common/providers/team_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamsPage extends ConsumerStatefulWidget {
  const TeamsPage({super.key});

  @override
  ConsumerState<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends ConsumerState<TeamsPage> {
  String _searchQuery = '';

  Future<void> _joinTeam(String teamId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to join a team.')),
      );
      return;
    }

    try {
      // Add the user to the team's users subcollection
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .collection('users')
          .doc(user.uid)
          .set({
        'userId': user.uid,
        'email': user.email,
        'name': user.displayName ?? 'Anonymous',
      });

      // Optionally, update the user's document to store the teamId
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'teamId': teamId});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully joined the team!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error joining team: $e')),
      );
    }
  }

  Future<bool> _isUserInTeam(String teamId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    final userDoc = await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .collection('users')
        .doc(user.uid)
        .get();

    return userDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    final teamStream = ref.watch(teamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
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
                hintText: 'Search teams...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: teamStream.when(
        data: (teams) {
          // Filter teams based on the search query
          final filteredTeams = teams.where((team) {
            return team.name.toLowerCase().contains(_searchQuery) ||
                team.description.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredTeams.isEmpty) {
            return const Center(child: Text('No teams found.'));
          }

          return ListView.builder(
            itemCount: filteredTeams.length,
            itemBuilder: (context, index) {
              final team = filteredTeams[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    team.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(team.description),
                  children: [
                    ...team.userNames.map((userName) {
                      return ListTile(
                        title: Text(userName),
                        leading: const Icon(Icons.person),
                      );
                    }).toList(),
                    FutureBuilder<bool>(
                      future: _isUserInTeam(team.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.data == true) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'You are already a member of this team.',
                              style: TextStyle(color: Colors.green),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => _joinTeam(team.id), // Pass the team ID
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