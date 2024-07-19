import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../services/firestore_service.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = Provider.of<FirestoreService>(context);
    
    // Replace 'courseId' with the actual course ID you're interested in
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: StreamBuilder<List<Topic>>(
        stream: firestoreService.getTopics('courseId'), // Replace with actual courseId
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final topics = snapshot.data!;
            if (topics.isEmpty) {
              return const Center(child: Text('No reminders found'));
            }
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(topics[index].title),
                  subtitle: Text('Duration: ${topics[index].duration} mins'),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      await firestoreService.deleteTopic(topics[index].id);
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
