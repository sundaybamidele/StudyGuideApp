import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/course.dart';

class CreateCourseScreen extends StatelessWidget {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  CreateCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Course newCourse = Course(
                  title: _titleController.text,
                  description: _descriptionController.text,
                );
                await _firestoreService.addCourse(newCourse);
                Navigator.pop(context);
              },
              child: const Text('Create Course'),
            ),
          ],
        ),
      ),
    );
  }
}
