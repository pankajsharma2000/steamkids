import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _backgroundClearanceStatus = 'Pending'; // Default status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Subscription'),
            subtitle: const Text('Basic'),
            leading: const Icon(Icons.subscriptions),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Background Clearance'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<String>(
                  title: const Text('Completed'),
                  value: 'Completed',
                  groupValue: _backgroundClearanceStatus,
                  onChanged: (value) {
                    setState(() {
                      _backgroundClearanceStatus = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Pending'),
                  value: 'Pending',
                  groupValue: _backgroundClearanceStatus,
                  onChanged: (value) {
                    setState(() {
                      _backgroundClearanceStatus = value!;
                    });
                  },
                ),
              ],
            ),
            leading: const Icon(Icons.verified_user),
          ),
        ],
      ),
    );
  }
}