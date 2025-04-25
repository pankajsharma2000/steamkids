import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamkids/common/providers/team_provider.dart';

class TeamsPage extends ConsumerWidget {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamStream = ref.watch(teamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Teams')),
      body: teamStream.when(
        data: (teams) {
          if (teams.isEmpty) {
            return const Center(child: Text('No teams found.'));
          }
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(team.name.isNotEmpty ? team.name[0] : '?'),
                  ),
                  title: Text(
                    team.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(team.description),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle tile tap (e.g., navigate to team details)
                  },
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