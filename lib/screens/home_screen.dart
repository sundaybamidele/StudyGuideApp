import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/firestore_service.dart';
import 'create_course_screen.dart';
import 'course_screen.dart'; // Import the course screen

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageCoursesScreen()),
                );
              },
              child: const Text('Manage Courses'),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageCoursesScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  ManageCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateCourseScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Course>>(
        stream: _firestoreService.getCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses available'));
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
                    MaterialPageRoute(
                      builder: (context) => CourseScreen(course: course),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateCourseScreen(course: course),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _firestoreService.deleteCourse(course.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
