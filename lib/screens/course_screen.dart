import 'package:flutter/material.dart';
import 'package:studyguideapp/screens/create_topic_screen.dart';
// ignore: unused_import
import '../models/course.dart';
import '../models/topic.dart'; // Import the Topic model
import '../services/firestore_service.dart';

class CourseScreen extends StatefulWidget {
  final String courseId;

  // ignore: use_super_parameters
  const CourseScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Stream<List<Topic>> _topicsStream;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _topicsStream = _firestoreService.getTopics(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Topics'),
      ),
      body: StreamBuilder<List<Topic>>(
        stream: _topicsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final topics = snapshot.data ?? [];

          if (topics.isEmpty) {
            return const Center(child: Text('No topics available.'));
          }

          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return ListTile(
                title: Text(topic.title),
                subtitle: Text(topic.content),
                onTap: () {
                  // Navigate to TopicScreen or any other relevant screen
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
              builder: (context) => CreateTopicScreen(courseId: widget.courseId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
