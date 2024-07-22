import 'package:flutter/material.dart';
import 'package:studyguideapp/screens/create_course_screen.dart';
import 'package:studyguideapp/screens/topic_screen.dart';
import '../models/course.dart';
import '../services/firestore_service.dart';

class CourseScreen extends StatefulWidget {
  final String courseId;

  // ignore: use_super_parameters
  const CourseScreen({Key? key, this.courseId = ''}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<Course>> _coursesStream;
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _coursesStream = _firestoreService.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: StreamBuilder<List<Course>>(
        stream: _coursesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          _courses = snapshot.data ?? [];

          if (_courses.isEmpty) {
            return const Center(child: Text('No courses available.'));
          }

          return ListView.builder(
            itemCount: _courses.length,
            itemBuilder: (context, index) {
              final course = _courses[index];
              return ListTile(
                title: Text(course.title),
                subtitle: Text(course.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicScreen(courseId: course.id, topicId: '',),
                    ),
                  );
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
            MaterialPageRoute(builder: (context) => const CreateCourseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
