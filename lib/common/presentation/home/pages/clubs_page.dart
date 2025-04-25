import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamkids/common/providers/club_provider.dart';

class ClubsPage extends ConsumerStatefulWidget {
  const ClubsPage({super.key});

  @override
  ConsumerState<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends ConsumerState<ClubsPage> {
  String _searchQuery = '';

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
                  children: club.userNames.map((userName) {
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