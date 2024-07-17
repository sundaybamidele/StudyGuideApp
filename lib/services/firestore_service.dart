import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../models/topic.dart';

class FirestoreService {
  final CollectionReference coursesCollection = FirebaseFirestore.instance.collection('courses');
  final CollectionReference topicsCollection = FirebaseFirestore.instance.collection('topics');

  // Create a new course
  Future<void> createCourse(String title, String description) async {
    try {
      await coursesCollection.add({
        'title': title,
        'description': description,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('Course created successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating course: $e');
      }
    }
  }

  // Get all courses
  Stream<List<Course>> getCourses() {
    return coursesCollection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList()
    );
  }

  // Get topics for a specific course
  Stream<List<Topic>> getTopics(String courseId) {
    return topicsCollection.where('course_id', isEqualTo: courseId).snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Topic.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList()
    );
  }

  // Placeholder methods (to be implemented if needed)
  addCourse(Course newCourse) {}
  addTopic(String courseId, Topic newTopic) {}
  deleteReminder(String s, String t) {}
}
