import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';
import 'create_topic_screen.dart';

class TopicListScreen extends StatelessWidget {
  final String courseId;

  const TopicListScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    //....
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
        stream: firestoreService.getTopics(courseId, userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching topics: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No topics found'));
          }

          final topics = snapshot.data!;
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTopicScreen(
                              courseId: courseId,
                              topic: topic,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Topic'),
                            content: const Text('Are you sure you want to delete this topic?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true) {
                          await firestoreService.deleteTopic(topic.id);
                        }
                      },
                    ),
                  ],
                ),
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
