import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamkids/common/providers/user_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userStream = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
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
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: userStream.when(
        data: (users) {
          final filteredUsers = users.where((user) {
            return user.name.toLowerCase().contains(_searchQuery) ||
                user.email.toLowerCase().contains(_searchQuery) ||
                user.skills.toLowerCase().contains(_searchQuery) ||
                user.interests.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredUsers.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.photoUrl.isNotEmpty
                        ? NetworkImage(user.photoUrl)
                        : null,
                    child: user.photoUrl.isEmpty
                        ? Text(user.name.isNotEmpty ? user.name[0] : '?')
                        : null,
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user.email}'),
                      Text('Skills: ${user.skills}'),
                      Text('Interests: ${user.interests}'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('Role: '),
                          Chip(
                            label: Text(
                              user.role,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: _getRoleColor(user.role),
                          ),
                        ],
                      ),
                      Text('YouTube: ${user.youtube}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle tile tap (e.g., navigate to user details)
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

  // Helper function to get color based on role
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return Colors.blue;
      case 'mentor':
        return Colors.green;
      case 'parent':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}