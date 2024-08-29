import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:studyguideapp/screens/create_topic_screen.dart';
import '../models/topic.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart'; // Import AuthService to get the current user

class CourseScreen extends StatefulWidget {
  final String courseId;

  const CourseScreen({super.key, required this.courseId});

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Stream<List<Topic>> _topicsStream;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();

    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.uid;

    if (userId != null) {
      _topicsStream = _firestoreService.getTopics(widget.courseId, userId); // Pass both courseId and userId
    } else {
      // Handle case where userId is null, if needed
      _topicsStream = const Stream.empty(); // Provide an empty stream to avoid errors
    }
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
