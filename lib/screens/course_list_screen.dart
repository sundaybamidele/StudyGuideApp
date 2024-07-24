import 'package:flutter/material.dart';
import 'package:studyguideapp/models/course.dart';
import 'package:studyguideapp/screens/create_course_screen.dart';

class CourseListScreen extends StatelessWidget {
  // Mock list of courses, replace with your actual data
  final List<Course> courses = [];

  CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return ListTile(
            title: Text(course.title),
            subtitle: Text(course.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateCourseScreen(
                    courseId: course.id,
                    initialTitle: course.title,
                    initialDescription: course.description,
                  ),
                ),
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
              builder: (context) => const CreateCourseScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
