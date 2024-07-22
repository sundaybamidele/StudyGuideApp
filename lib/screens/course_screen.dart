import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyguideapp/services/firestore_service.dart';
import '../models/course.dart'; // Ensure this import is correct

class CourseScreen extends StatelessWidget {
  final String courseId; // The ID of the course to be displayed

  const CourseScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return FutureBuilder<Course?>(
      future: firestoreService.getCourse(courseId), // Implement this method in FirestoreService
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Course not found'));
        }

        final course = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(course.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${course.title}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Description: ${course.description}',
                  style: const TextStyle(fontSize: 16),
                ),
                // Add more widgets to display course details
              ],
            ),
          ),
        );
      },
    );
  }
}
