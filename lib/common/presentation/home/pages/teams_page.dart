import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamkids/common/providers/team_provider.dart';

class TeamsPage extends ConsumerStatefulWidget {
  const TeamsPage({super.key});

  @override
  ConsumerState<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends ConsumerState<TeamsPage> {
  String _searchQuery = '';

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
                  children: team.userNames.map((userName) {
                    return ListTile(
                      title: Text(userName),
                      leading: const Icon(Icons.person),
                    );
                  }).toList(),
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