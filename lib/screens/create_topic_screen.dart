import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class CreateTopicScreen extends StatelessWidget {
  final String courseId;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  CreateTopicScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Topic'),
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
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _firestoreService.createTopic(
                  courseId,
                  _titleController.text,
                  _contentController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Create Topic'),
            ),
          ],
        ),
      ),
    );
  }
}
