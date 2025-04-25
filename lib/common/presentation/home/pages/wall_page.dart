import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WallPage extends StatefulWidget {
  const WallPage({super.key});

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('wall_messages');

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final user = FirebaseAuth.instance.currentUser; // Get the authenticated user
    if (user == null) {
      // Handle unauthenticated user (e.g., show an error or redirect to login)
      return;
    }

    await _messagesCollection.add({
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': user.uid, // Store the user's unique ID
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wall')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true, // Show the latest message at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final userId = message['userId'];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: Text('Loading user...'),
                          );
                        }

                        if (!userSnapshot.hasData ||
                            !userSnapshot.data!.exists) {
                          return const ListTile(
                            title: Text('Unknown User'),
                            subtitle: Text('Message could not be linked to a user.'),
                          );
                        }

                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        final userName = userData['name'] ?? 'Anonymous';
                        final userProfilePic = userData['profilePic'] ?? '';

                        return ListTile(
                          leading: userProfilePic.isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(userProfilePic),
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                          title: Text(userName),
                          subtitle: Text(message['message']),
                          trailing: Text(
                            message['timestamp'] != null
                                ? _formatTimestamp(
                                    message['timestamp'].toDate())
                                : '',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format timestamps
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}