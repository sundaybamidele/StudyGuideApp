import 'package:flutter/material.dart';
import 'package:studyguideapp/models/topic.dart';
import 'package:studyguideapp/screens/create_topic_screen.dart';

class TopicListScreen extends StatelessWidget {
  final String courseId;

  // Mock list of topics, replace with your actual data
  final List<Topic> topics = [];

  TopicListScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return ListTile(
            title: Text(topic.title),
            subtitle: Text(topic.content),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTopicScreen(
                    courseId: courseId,
                    topicId: topic.id,
                    initialTitle: topic.title,
                    initialContent: topic.content,
                    initialDuration: topic.duration,
                  ),
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
