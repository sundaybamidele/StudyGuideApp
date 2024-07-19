import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../models/topic.dart';
import '../models/assessment_result.dart'; // Import the assessment result model
import 'notification_service.dart';  // Import the notification service

class FirestoreService {
  final CollectionReference coursesCollection = FirebaseFirestore.instance.collection('courses');
  final CollectionReference topicsCollection = FirebaseFirestore.instance.collection('topics');
  final CollectionReference assessmentResultsCollection = FirebaseFirestore.instance.collection('assessment_results'); // New collection for assessment results

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
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }

  // Create a new topic
  Future<void> createTopic(String courseId, String title, String content, int duration) async {
    try {
      var docRef = await topicsCollection.add({
        'course_id': courseId,
        'title': title,
        'content': content,
        'duration': duration,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      await scheduleNotification(
        docRef.id.hashCode,
        title,
        'Study this topic now!',
        duration,
      );
      if (kDebugMode) {
        print('Topic created successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating topic: $e');
      }
      rethrow;
    }
  }

  // Update an existing topic
  Future<void> updateTopic(String topicId, String title, String content, int duration) async {
    try {
      await topicsCollection.doc(topicId).update({
        'title': title,
        'content': content,
        'duration': duration,
        'updated_at': FieldValue.serverTimestamp(),
      });
      await scheduleNotification(
        topicId.hashCode,
        title,
        'Study this topic now!',
        duration,
      );
      if (kDebugMode) {
        print('Topic updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating topic: $e');
      }
      rethrow;
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
      rethrow;
    }
  }

  // Save assessment result
  Future<void> saveAssessmentResult(AssessmentResult result) async {
    try {
      await assessmentResultsCollection.add(result.toMap());
      if (kDebugMode) {
        print('Assessment result saved successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving assessment result: $e');
      }
      rethrow;
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

  // Get assessment results (optional)
  Stream<List<AssessmentResult>> getAssessmentResults() {
    return assessmentResultsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => AssessmentResult.fromMap(doc.data() as Map<String, dynamic>)).toList()
    );
  }
}
