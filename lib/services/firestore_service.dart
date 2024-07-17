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
      rethrow; // Optional: rethrow the error to handle it in the UI
    }
  }

  // Update an existing course
  Future<void> updateCourse(String courseId, String title, String description) async {
    try {
      await coursesCollection.doc(courseId).update({
        'title': title,
        'description': description,
        'updated_at': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('Course updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating course: $e');
      }
      rethrow; // Optional: rethrow the error to handle it in the UI
    }
  }

  // Delete a course
  Future<void> deleteCourse(String courseId) async {
    try {
      await coursesCollection.doc(courseId).delete();
      if (kDebugMode) {
        print('Course deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting course: $e');
      }
      rethrow; // Optional: rethrow the error to handle it in the UI
    }
  }

  // Create a new topic
  Future<void> createTopic(String courseId, String title, String content) async {
    try {
      await topicsCollection.add({
        'course_id': courseId,
        'title': title,
        'content': content,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('Topic created successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating topic: $e');
      }
      rethrow; // Optional: rethrow the error to handle it in the UI
    }
  }

  // Update an existing topic
  Future<void> updateTopic(String topicId, String title, String content) async {
    try {
      await topicsCollection.doc(topicId).update({
        'title': title,
        'content': content,
        'updated_at': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('Topic updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating topic: $e');
      }
      rethrow; // Optional: rethrow the error to handle it in the UI
    }
  }

  // Delete a topic
  Future<void> deleteTopic(String topicId) async {
    try {
      await topicsCollection.doc(topicId).delete();
      if (kDebugMode) {
        print('Topic deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting topic: $e');
      }
      rethrow; // Optional: rethrow the error to handle it in the UI
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
}
