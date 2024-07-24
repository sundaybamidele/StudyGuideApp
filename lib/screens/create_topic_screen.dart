import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';

class CreateTopicScreen extends StatefulWidget {
  final String courseId;
  final String? topicId;
  final String? initialTitle;
  final String? initialContent;
  final int? initialDuration;

  const CreateTopicScreen({
    required this.courseId,
    this.topicId,
    this.initialTitle,
    this.initialContent,
    this.initialDuration,
    super.key,
  });

  @override
  _CreateTopicScreenState createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.topicId != null) {
      _titleController.text = widget.initialTitle ?? '';
      _contentController.text = widget.initialContent ?? '';
      _durationController.text = widget.initialDuration?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicId == null ? 'Create Topic' : 'Update Topic'),
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text;
                final content = _contentController.text;
                final duration = int.tryParse(_durationController.text) ?? 0;

                if (title.isNotEmpty && content.isNotEmpty && duration > 0) {
                  try {
                    if (widget.topicId == null) {
                      await firestoreService.createTopic(
                        courseId: widget.courseId,
                        title: title,
                        content: content,
                        duration: duration,
                      );
                    } else {
                      await firestoreService.updateTopic(
                        topicId: widget.topicId!,
                        title: title,
                        content: content,
                        duration: duration,
                      );
                    }
                    Navigator.pop(context); // Navigate back to the previous screen
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error saving topic: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Text(widget.topicId == null ? 'Create Topic' : 'Update Topic'),
            ),
          ],
        ),
      ),
    );
  }
}
