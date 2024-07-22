import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyguideapp/services/firestore_service.dart';
import '../models/topic.dart';

class TopicScreen extends StatelessWidget {
  final String topicId; // The ID of the topic to be edited or viewed

  const TopicScreen({super.key, required this.topicId, required String courseId});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return FutureBuilder<Topic?>(
      future: firestoreService.getTopic(topicId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Topic not found'));
        }

        final topic = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(topic.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${topic.title}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Content: ${topic.content}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Duration: ${topic.duration} minutes',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                // Removed Options section
              ],
            ),
          ),
        );
      },
    );
  }
}
