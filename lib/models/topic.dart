import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final int duration;
  final bool completed;
  final String userId;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Topic({
    required this.id,
    required this.courseId,
    required this.title,
    required this.content,
    required this.duration,
    required this.completed,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Topic.fromFirestore(Map<String, dynamic> firestore, String id) {
    return Topic(
      id: id,
      courseId: firestore['course_id'] as String,
      title: firestore['title'] as String,
      content: firestore['content'] as String,
      duration: firestore['duration'] as int,
      completed: firestore['completed'] as bool,
      userId: firestore['userId'] as String,
      createdAt: firestore['created_at'] as Timestamp,
      updatedAt: firestore['updated_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'course_id': courseId,
      'title': title,
      'content': content,
      'duration': duration,
      'completed': completed,
      'userId': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
