import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/topic.dart';

class CreateTopicScreen extends StatefulWidget {
  final String courseId;
  final Topic? topic;

  const CreateTopicScreen({super.key, required this.courseId, this.topic});

  @override
  CreateTopicScreenState createState() => CreateTopicScreenState();
}

class CreateTopicScreenState extends State<CreateTopicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _durationController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    if (widget.topic != null) {
      _titleController.text = widget.topic!.title;
      _contentController.text = widget.topic!.content;
      _durationController.text = widget.topic!.studyDuration.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic == null ? 'Create Topic' : 'Edit Topic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Study Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      if (widget.topic == null) {
                        await _firestoreService.createTopic(
                          widget.courseId,
                          _titleController.text,
                          _contentController.text,
                          int.parse(_durationController.text),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Topic created successfully')),
                        );
                      } else {
                        await _firestoreService.updateTopic(
                          widget.topic!.id,
                          _titleController.text,
                          _contentController.text,
                          int.parse(_durationController.text),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Topic updated successfully')),
                        );
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error creating/updating topic: $e')),
                      );
                    }
                  }
                },
                child: Text(widget.topic == null ? 'Create Topic' : 'Save Topic'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
