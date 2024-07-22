import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../models/topic.dart';
import '../services/firestore_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: StreamBuilder<List<Course>>(
        stream: firestoreService.getCourses(),
        builder: (context, courseSnapshot) {
          if (courseSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (courseSnapshot.hasError) {
            return Center(child: Text('Error: ${courseSnapshot.error}'));
          }

          if (!courseSnapshot.hasData || courseSnapshot.data!.isEmpty) {
            return const Center(child: Text('No courses available'));
          }

          final courses = courseSnapshot.data!;
          return ListView(
            children: courses.map((course) {
              return StreamBuilder<List<Topic>>(
                stream: firestoreService.getTopics(course.id),
                builder: (context, topicSnapshot) {
                  if (topicSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (topicSnapshot.hasError) {
                    return Center(child: Text('Error: ${topicSnapshot.error}'));
                  }

                  if (!topicSnapshot.hasData || topicSnapshot.data!.isEmpty) {
                    return ListTile(
                      title: Text(course.title),
                      subtitle: const Text('No topics available'),
                    );
                  }

                  final topics = topicSnapshot.data!;
                  return ExpansionTile(
                    title: Text(course.title),
                    children: topics.map((topic) {
                      return ListTile(
                        title: Text(
                          topic.title,
                          style: TextStyle(
                            color: topic.completed ? Colors.green : Colors.black,
                          ),
                        ),
                        subtitle: Text('Duration: ${topic.duration} mins'),
                        trailing: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            await firestoreService.updateTopicCompletion(topic.id, !topic.completed);
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
