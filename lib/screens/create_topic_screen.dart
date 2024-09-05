import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/user_profile.dart';
import '../models/topic.dart'; // Import Topic model

class CreateTopicScreen extends StatefulWidget {
  final String courseId;
  final Topic? topic; // Added topic parameter for editing

  const CreateTopicScreen({super.key, required this.courseId, this.topic});

  @override
  _CreateTopicScreenState createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _durationController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.topic != null) {
      _isEditing = true;
      _titleController.text = widget.topic!.title;
      _contentController.text = widget.topic!.content;
      _durationController.text = widget.topic!.duration.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final user = Provider.of<UserProfile>(context); // Retrieve the user profile

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Topic' : 'Create Topic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value?.isEmpty == true ? 'Title is required' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) => value?.isEmpty == true ? 'Content is required' : null,
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? 'Duration is required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    // Extract values from the text fields
                    final title = _titleController.text;
                    final content = _contentController.text;
                    final duration = int.parse(_durationController.text);
                    final userId = user.uid; // Retrieve the userId

                    if (_isEditing) {
                      // Update the existing topic
                      firestoreService.updateTopic(
                        topicId: widget.topic!.id,
                        title: title,
                        content: content,
                        duration: duration,
                        userId: userId,
                      ).then((_) {
                        Navigator.pop(context);
                      }).catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error updating topic: $e')),
                        );
                      });
                    } else {
                      // Create a new topic
                      firestoreService.createTopic(
                        courseId: widget.courseId,
                        title: title,
                        content: content,
                        duration: duration,
                        userId: userId,
                      ).then((_) {
                        Navigator.pop(context);
                      }).catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error creating topic: $e')),
                        );
                      });
                    }
                  }
                },
                child: Text(_isEditing ? 'Update Topic' : 'Create Topic'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
