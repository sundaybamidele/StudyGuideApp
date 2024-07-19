import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/topic.dart';
import '../models/assessment_result.dart'; // Define this model to handle results

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, int> _answers = {};
  int _totalScore = 0;

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment'),
      ),
      body: StreamBuilder<List<Topic>>(
        stream: firestoreService.getTopics('courseId'), // Replace with actual courseId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available'));
          }

          final topics = snapshot.data!;

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Assess Your Knowledge',
                  style: Theme.of(context).textTheme.headlineMedium, // Updated style
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: topics.map((topic) => buildQuestion(topic)).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _calculateScore();
                      _showResult();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildQuestion(Topic topic) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(topic.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question: ${topic.content}'),
            ...List.generate(
              topic.options.length,
              (index) => RadioListTile<int>(
                title: Text(topic.options[index]),
                value: index + 1,
                groupValue: _answers[topic.id],
                onChanged: (value) {
                  setState(() {
                    _answers[topic.id] = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateScore() {
    // Calculate score based on the answers provided
    _totalScore = _answers.values.where((answer) => answer == 1).length * 10;
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assessment Result'),
        content: Text('Your score: $_totalScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveResult();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _saveResult() async {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final result = AssessmentResult(
      score: _totalScore,
      timestamp: DateTime.now(),
      // Additional fields as needed
    );
    try {
      await firestoreService.saveAssessmentResult(result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assessment result saved successfully')),
        );
      }
    } catch (e) {
      final isDebugMode = bool.fromEnvironment('dart.vm.product') == false;

      if (isDebugMode) {
        print('Error saving assessment result: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving assessment result')),
      );
    }
  }
}
