import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final int duration;
  final List<String> options; // Add this field
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  Topic({
    required this.id,
    required this.courseId,
    required this.title,
    required this.content,
    required this.duration,
    required this.options,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Topic.fromFirestore(Map<String, dynamic> data, String id) {
    return Topic(
      id: id,
      courseId: data['course_id'],
      title: data['title'],
      content: data['content'],
      duration: data['duration'],
      options: List<String>.from(data['options'] ?? []),
      completed: data['completed'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'course_id': courseId,
      'title': title,
      'content': content,
      'duration': duration,
      'options': options,
      'completed': completed,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
