// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  int _usefulnessRating = 1;
  String _usageFrequency = 'Daily';
  String _gradesImprovement = 'Yes';
  int _navigationEaseRating = 1;
  int _satisfactionRating = 1;
  String _organizationEffect = 'Yes';
  int _contentQualityRating = 1;
  String _recommendation = 'Yes';
  String _suggestions = '';
  String _additionalComments = '';

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We value your feedback! Please let us know how we are doing.',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Email Address
                const Text(
                  'Your Email Address:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _email = value;
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Please provide your email address' : null,
                ),
                const SizedBox(height: 20),

                // Overall Usefulness
                const Text(
                  'Rate the overall usefulness of the app:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('1 - Very Poor, 5 - Excellent'),
                Slider(
                  value: _usefulnessRating.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '$_usefulnessRating',
                  onChanged: (value) {
                    setState(() {
                      _usefulnessRating = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Usage Frequency
                const Text(
                  'How often do you use the app for your studies?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Select the frequency with which you use the app.'),
                DropdownButtonFormField<String>(
                  value: _usageFrequency,
                  onChanged: (value) {
                    setState(() {
                      _usageFrequency = value!;
                    });
                  },
                  items: ['Daily', 'Weekly', 'Monthly', 'Rarely'].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null ? 'Please select an option' : null,
                ),
                const SizedBox(height: 20),

                // Grades Improvement
                const Text(
                  'Do you feel that using this app has improved your grades?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Rate on a scale of 1 to 5, where 1 is No and 5 is Yes.'),
                Slider(
                  value: _gradesImprovement == 'Yes' ? 5.0 : 1.0,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _gradesImprovement,
                  onChanged: (value) {
                    setState(() {
                      _gradesImprovement = value == 5 ? 'Yes' : 'No';
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Ease of Navigation
                const Text(
                  'Rate the ease of navigation through the app:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('1 - Very Difficult, 5 - Very Easy'),
                Slider(
                  value: _navigationEaseRating.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '$_navigationEaseRating',
                  onChanged: (value) {
                    setState(() {
                      _navigationEaseRating = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Satisfaction with Reminders
                const Text(
                  'Rate your satisfaction with reminders and notifications:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('1 - Very Unsatisfied, 5 - Very Satisfied'),
                Slider(
                  value: _satisfactionRating.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '$_satisfactionRating',
                  onChanged: (value) {
                    setState(() {
                      _satisfactionRating = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Effect on Organization
                const Text(
                  'Has the app helped you become more organized?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Rate on a scale of 1 to 5, where 1 is No and 5 is Yes.'),
                Slider(
                  value: _organizationEffect == 'Yes' ? 5.0 : 1.0,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _organizationEffect,
                  onChanged: (value) {
                    setState(() {
                      _organizationEffect = value == 5 ? 'Yes' : 'No';
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Content Quality
                const Text(
                  'Rate the quality of content provided in the app:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('1 - Very Poor, 5 - Excellent'),
                Slider(
                  value: _contentQualityRating.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '$_contentQualityRating',
                  onChanged: (value) {
                    setState(() {
                      _contentQualityRating = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Recommendation
                const Text(
                  'Would you recommend this app to others?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Rate on a scale of 1 to 5, where 1 is No and 5 is Yes.'),
                Slider(
                  value: _recommendation == 'Yes' ? 5.0 : 1.0,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _recommendation,
                  onChanged: (value) {
                    setState(() {
                      _recommendation = value == 5 ? 'Yes' : 'No';
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Suggestions
                const Text(
                  'Any suggestions for improving the app?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _suggestions = value;
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Please provide suggestions' : null,
                ),
                const SizedBox(height: 20),

                // Additional Comments
                const Text(
                  'Additional Comments',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _additionalComments = value;
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Please provide some comments' : null,
                ),
                const SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        await firestoreService.submitFeedback(
                          _email,
                          _usefulnessRating,
                          _usageFrequency,
                          _gradesImprovement,
                          _navigationEaseRating,
                          _satisfactionRating,
                          _organizationEffect,
                          _contentQualityRating,
                          _recommendation,
                          _suggestions,
                          _additionalComments,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Thank you for your feedback!')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error submitting feedback')),
                        );
                      }
                    }
                  },
                  child: const Text('Submit Feedback'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
