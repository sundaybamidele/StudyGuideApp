import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/firestore_service.dart';
import 'create_course_screen.dart';
import 'course_screen.dart';
import 'study_materials_screen.dart'; // Replace with your actual study materials screen
import 'assessment_screen.dart'; // Replace with your actual assessment screen
import 'reminder_screen.dart'; // Replace with your actual reminder screen
import 'login_screen.dart'; // Replace with your actual login screen

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  HomeScreen({super.key});

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('Study Materials'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyMaterialsScreen()), // Replace with your actual study materials screen
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Assessment'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AssessmentScreen()), // Replace with your actual assessment screen
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Reminder'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReminderScreen()), // Replace with your actual reminder screen
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Implement logout functionality
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your actual login screen
                  (Route<dynamic> route) => false, // Removes all routes from the stack, preventing back navigation
                );
              },
            ),
          ],
        ),
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
