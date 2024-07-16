import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/firestore_service.dart';
import 'create_topic_screen.dart';
import '../models/topic.dart';

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
                MaterialPageRoute(builder: (context) => CreateTopicScreen(courseId: course.id)),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Topic>>(
        stream: _firestoreService.getTopics(course.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No topics available'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Topic topic = snapshot.data![index];
              return ListTile(
                title: Text(topic.title),
                subtitle: Text(topic.content),
              );
            },
          );
        },
      ),
    );
  }
}
