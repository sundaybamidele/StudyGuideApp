import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/user_profile.dart';

class CreateTopicScreen extends StatefulWidget {
  final String courseId;

  const CreateTopicScreen({super.key, required this.courseId});

  @override
  _CreateTopicScreenState createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final user = Provider.of<UserProfile>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Topic'),
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
                    final title = _titleController.text;
                    final content = _contentController.text;
                    final duration = int.parse(_durationController.text);
                    final userId = user.uid;

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
                },
                child: const Text('Create Topic'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
