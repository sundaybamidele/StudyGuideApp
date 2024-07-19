import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/topic.dart';
import '../services/firestore_service.dart';
import 'create_topic_screen.dart';

class CourseScreen extends StatelessWidget {
  final Course course;
  final FirestoreService _firestoreService = FirestoreService();

  CourseScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTopicScreen(courseId: course.id, topic: null),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Topic>>(
        stream: _firestoreService.getTopics(course.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No topics found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Topic topic = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(topic.title),
                  subtitle: Text(topic.content),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editTopic(context, topic);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteTopic(context, topic.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _editTopic(BuildContext context, Topic topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTopicScreen(courseId: course.id, topic: topic),
      ),
    );
  }

  void _deleteTopic(BuildContext context, String topicId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Topic'),
          content: const Text('Are you sure you want to delete this topic?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                try {
                  await _firestoreService.deleteTopic(topicId);
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting topic: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
