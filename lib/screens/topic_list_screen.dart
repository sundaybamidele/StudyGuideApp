import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../models/user_profile.dart'; // Corrected import for UserProfile
import '../services/firestore_service.dart';
import 'create_topic_screen.dart';

class TopicListScreen extends StatelessWidget {
  final String courseId;

  // ignore: use_super_parameters
  const TopicListScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    
    // Retrieve userProfile from the provider
    UserProfile? userProfile;
    try {
      userProfile = Provider.of<UserProfile>(context, listen: false);
    } catch (e) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Topics'),
        ),
        body: Center(
          child: Text('UserProfile provider not found: ${e.toString()}'),
        ),
      );
    }
    
    final userId = userProfile.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
      ),
      body: StreamBuilder<List<Topic>>(
        stream: firestoreService.getTopics(courseId, userId), // Provide courseId and userId here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching topics: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No topics found'));
          }

          final topics = snapshot.data!;
          // Debugging print statements
          if (kDebugMode) {
            print('Fetched ${topics.length} topics');
          }
          for (var topic in topics) {
            if (kDebugMode) {
              print('Topic: ${topic.title}, Completed: ${topic.completed}');
            }
          }

          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return ListTile(
                title: Text(topic.title),
                subtitle: Text('Duration: ${topic.duration} minutes'),
                onTap: () {
                  // Navigate to the topic detail or edit screen
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTopicScreen(courseId: courseId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
