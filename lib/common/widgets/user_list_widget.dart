import 'package:flutter/material.dart';
import 'package:steamkids/common/providers/user_provider.dart';

class UserListWidget extends StatelessWidget {
  final List<User> users;

  const UserListWidget({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
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
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundImage: user.photoUrl.isNotEmpty
                  ? NetworkImage(user.photoUrl)
                  : null,
              child: user.photoUrl.isEmpty
                  ? Text(user.name.isNotEmpty ? user.name[0] : '?')
                  : null,
            ),
            title: Align(
              alignment: Alignment.centerLeft, // Force left alignment for the title
              child: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Align(
              alignment: Alignment.centerLeft, // Force left alignment for the subtitle
              child: Row(
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
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Ensure left alignment for expanded content
                  children: [
                    Align(
                      alignment: Alignment.centerLeft, // Force left alignment for each text
                      child: Text(
                        'Email: ${user.email}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Skills: ${user.skills}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Interests: ${user.interests}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (user.role.toLowerCase() == 'mentor') ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Text('Rating: '),
                            _buildStarRating(user.rating),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'YouTube: ${user.youtube}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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