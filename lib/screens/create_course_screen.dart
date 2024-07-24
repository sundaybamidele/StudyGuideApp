import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyguideapp/services/firestore_service.dart';

class CreateCourseScreen extends StatefulWidget {
  final String? courseId;
  final String? initialTitle;
  final String? initialDescription;

  const CreateCourseScreen({
    super.key,
    this.courseId,
    this.initialTitle,
    this.initialDescription,
  });

  @override
  _CreateCourseScreenState createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.courseId != null) {
      _titleController.text = widget.initialTitle ?? '';
      _descriptionController.text = widget.initialDescription ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Course'),
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
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text;
                final description = _descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  try {
                    if (widget.courseId == null) {
                      // Creating a new course
                      await firestoreService.createCourse(title, description);
                    } else {
                      // Updating an existing course
                      await firestoreService.updateCourse(
                        widget.courseId!,
                        title,
                        description,
                      );
                    }
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error saving course: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Text(widget.courseId == null ? 'Create Course' : 'Update Course'),
            ),
          ],
        ),
      ),
    );
  }
}
