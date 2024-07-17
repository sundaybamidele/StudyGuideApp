import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyguideapp/models/topic.dart';
import '../services/firestore_service.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = Provider.of<FirestoreService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: StreamBuilder<List<Topic>>(
        stream: firestoreService.getTopics(context.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final topics = snapshot.data!;
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(topics[index].title),
                  subtitle: Text('Duration: ${topics[index].studyDuration} mins'),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      await firestoreService.deleteTopic(topics[index].id!);
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}