import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../services/firestore_service.dart';
import 'create_topic_screen.dart';

class TopicListScreen extends StatelessWidget {
  final String courseId;

  // ignore: use_super_parameters
  const TopicListScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
      ),
      body: StreamBuilder<List<Topic>>(
        stream: firestoreService.getTopics(courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching topics'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No topics found'));
          }

          final topics = snapshot.data!;
          // ignore: avoid_print
          print('Fetched ${topics.length} topics'); // Debugging print statement

          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return ListTile(
                title: Text(topic.title),
                subtitle: Text('Duration: ${topic.duration} minutes'),
                onTap: () {
                  // Navigate to the topic detail or edit screen
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTopicScreen(courseId: courseId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
