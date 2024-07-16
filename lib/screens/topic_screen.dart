import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/topic.dart';

class TopicScreen extends StatefulWidget {
  final String courseId;

  const TopicScreen({super.key, required this.courseId});

  @override
  // ignore: library_private_types_in_public_api
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  
  bool? get kDebugMode => null;

  void _createTopic() async {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      Topic topic = Topic(
        title: _titleController.text,
        content: _contentController.text,
        courseId: widget.courseId,
        duration: 0, // Changed from null to 0
      );
      try {
        await _firestoreService.addTopic(topic as String, widget.courseId as Topic);
        Navigator.of(context).pop(); // Close the dialog or navigate away
      } catch (e) {
        if (kDebugMode != null && kDebugMode!) {
          // ignore: avoid_print
          print(e);
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to create topic.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter all fields.'),
      ));
    }
  }

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
              onPressed: _createTopic,
              child: const Text('Create Topic'),
            ),
          ],
        ),
      ),
    );
  }
}
