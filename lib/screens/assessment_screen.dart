import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/course.dart';
import '../models/topic.dart';
import '../services/auth_service.dart'; // Import AuthService to get the current user

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.uid; // Get the userId

    if (userId == null) {
      return const Center(child: Text('No user logged in'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment'),
      ),
      body: StreamBuilder<List<Course>>(
        stream: firestoreService.getCourses(userId), // Pass the userId
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
                stream: firestoreService.getTopics(course.id, userId), // Pass both courseId and userId
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
                  final completedTopics = topics.where((topic) => topic.completed).length;
                  final totalTopics = topics.length;
                  final completionPercentage = (completedTopics / totalTopics) * 100;

                  return ListTile(
                    title: Text(course.title),
                    subtitle: Text('Completion: ${completionPercentage.toStringAsFixed(2)}%'),
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
