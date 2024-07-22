import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyguideapp/services/firestore_service.dart';

class CreateTopicScreen extends StatefulWidget {
  final String courseId; // The ID of the course to which the topic belongs

  const CreateTopicScreen({super.key, required this.courseId});

  @override
  // ignore: library_private_types_in_public_api
  _CreateTopicScreenState createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _durationController = TextEditingController();
  final _optionsController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Topic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duration (in minutes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _optionsController,
              decoration: const InputDecoration(labelText: 'Options (comma separated)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text;
                final content = _contentController.text;
                final duration = int.tryParse(_durationController.text) ?? 0;
                final options = _optionsController.text.split(',').map((option) => option.trim()).toList();
                
                if (title.isNotEmpty && content.isNotEmpty && duration > 0) {
                  try {
                    await firestoreService.createTopic(
                      courseId: widget.courseId,
                      title: title,
                      content: content,
                      duration: duration,
                      options: options,
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    // Handle any errors that occur
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error creating topic: $e')),
                    );
                  }
                } else {
                  // Handle validation error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields correctly')),
                  );
                }
              },
              child: const Text('Create Topic'),
            ),
          ],
        ),
      ),
    );
  }
}
