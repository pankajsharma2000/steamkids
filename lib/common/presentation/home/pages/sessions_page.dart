import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate a list of sessions
    final List<Map<String, String>> sessions = _generateSessions();

    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: Text('Session ${index + 1}'),
              subtitle: Text('${session['date']} | ${session['start']} - ${session['end']}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _openGoogleCalendar(session);
              },
            ),
          );
        },
      ),
    );
  }

  // Helper function to generate a list of random 1-hour sessions spanning the next month
  List<Map<String, String>> _generateSessions() {
    final List<Map<String, String>> sessions = [];
    final random = Random();

    for (int i = 0; i < 10; i++) { // Generate 10 random sessions
      // Generate a random date within the next 30 days
      final randomDays = random.nextInt(30); // Random number of days from today
      final randomHours = random.nextInt(24); // Random hour of the day
      final randomMinutes = random.nextInt(60); // Random minute of the hour

      DateTime startTime = DateTime.now()
          .add(Duration(days: randomDays))
          .add(Duration(hours: randomHours, minutes: randomMinutes));
      final endTime = startTime.add(const Duration(hours: 1)); // 1-hour session

      sessions.add({
        'date': _formatDate(startTime),
        'start': _formatTime(startTime),
        'end': _formatTime(endTime),
        'startDateTime': startTime.toIso8601String(),
        'endDateTime': endTime.toIso8601String(),
      });
    }

    return sessions;
  }

  // Helper function to format time as HH:mm
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Helper function to format date as YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Function to open Google Calendar with the session's time highlighted
  Future<void> _openGoogleCalendar(Map<String, String> session) async {
    final startDateTime = session['startDateTime']!;
    final endDateTime = session['endDateTime']!;
    final url = Uri.parse(
      'https://calendar.google.com/calendar/render?action=TEMPLATE'
      '&dates=$startDateTime/$endDateTime'
      '&text=STEAM+Session'
      '&details=Join+this+STEAM+session',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}