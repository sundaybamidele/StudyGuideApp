import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:studyguideapp/services/notification_service.dart';
import '../models/course.dart';
import '../models/topic.dart';
import '../models/assessment_result.dart'; // Import the assessment result model

class FirestoreService {
  final CollectionReference coursesCollection = FirebaseFirestore.instance.collection('courses');
  final CollectionReference topicsCollection = FirebaseFirestore.instance.collection('topics');
  final CollectionReference assessmentResultsCollection = FirebaseFirestore.instance.collection('assessment_results'); // New collection for assessment results
  final CollectionReference feedbackCollection = FirebaseFirestore.instance.collection('feedback'); // New collection for feedback

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

  // Get assessment results
  Stream<List<AssessmentResult>> getAssessmentResults() {
    return assessmentResultsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => AssessmentResult.fromMap(doc.data() as Map<String, dynamic>)).toList()
    );
  }

  // Save feedback
  Future<void> submitFeedback(
    int usefulnessRating,
    String usageFrequency,
    String gradesImprovement,
    int navigationEaseRating,
    int satisfactionRating,
    String organizationEffect,
    int contentQualityRating,
    String recommendation,
    String suggestions,
    String additionalComments
  ) async {
    try {
      // Check if ratings are within expected range (e.g., 1 to 5)
      if (usefulnessRating < 1 || usefulnessRating > 5 ||
          navigationEaseRating < 1 || navigationEaseRating > 5 ||
          satisfactionRating < 1 || satisfactionRating > 5 ||
          contentQualityRating < 1 || contentQualityRating > 5) {
        throw ArgumentError('Ratings must be between 1 and 5');
      }

      await feedbackCollection.add({
        'usefulnessRating': usefulnessRating,
        'usageFrequency': usageFrequency,
        'gradesImprovement': gradesImprovement,
        'navigationEaseRating': navigationEaseRating,
        'satisfactionRating': satisfactionRating,
        'organizationEffect': organizationEffect,
        'contentQualityRating': contentQualityRating,
        'recommendation': recommendation,
        'suggestions': suggestions,
        'additionalComments': additionalComments,
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('Feedback submitted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting feedback: $e');
      }
      rethrow;
    }
  }
}
