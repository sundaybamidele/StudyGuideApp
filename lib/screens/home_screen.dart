import 'package:flutter/material.dart';
import 'package:studyguideapp/services/firestore_service.dart';

import '../models/course.dart';
import 'course_screen.dart';
import 'create_course_screen.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateCourseScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Course>>(
        stream: _firestoreService.getCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No courses available');
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Course course = snapshot.data![index];
              return ListTile(
                title: Text(course.title),
                subtitle: Text(course.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CourseScreen(course: course)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
