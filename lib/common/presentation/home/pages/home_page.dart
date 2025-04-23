import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamkids/common/providers/user_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStream = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: userStream.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.photoUrl.isNotEmpty
                        ? NetworkImage(user.photoUrl) // Load image from URL
                        : null,
                    child: user.photoUrl.isEmpty
                        ? Text(user.name.isNotEmpty ? user.name[0] : '?') // Fallback to initials
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
                      if (user.role.toLowerCase() == 'mentor') ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text('Rating: '),
                            _buildStarRating(user.rating),
                          ],
                        ),
                      ],
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

  // Helper function to build star rating
  Widget _buildStarRating(int rating) {
    const int maxStars = 5;
    return Row(
      children: List.generate(maxStars, (index) {
        if (index < rating) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 16);
        }
      }),
    );
  }
}