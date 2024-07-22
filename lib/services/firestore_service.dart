import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:studyguideapp/services/notification_service.dart';
import '../models/course.dart';
import '../models/topic.dart';
import '../models/assessment_result.dart'; // Import the assessment result model

class FirestoreService {
  final CollectionReference coursesCollection = FirebaseFirestore.instance.collection('courses');
  final CollectionReference topicsCollection = FirebaseFirestore.instance.collection('topics');
  final CollectionReference assessmentResultsCollection = FirebaseFirestore.instance.collection('assessment_results'); // New collection for assessment results
  final CollectionReference feedbackCollection = FirebaseFirestore.instance.collection('feedback'); // New collection for feedback
  final FirebaseFunctions functions = FirebaseFunctions.instance; // Initialize Firebase Functions

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
  Future<void> createTopic({
    required String courseId,
    required String title,
    required String content,
    required int duration,
  }) async {
    try {
      var docRef = await topicsCollection.add({
        'course_id': courseId,
        'title': title,
        'content': content,
        'duration': duration,
        'completed': false, // Initialize as not completed
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
  Future<void> updateTopic({
    required String topicId,
    required String title,
    required String content,
    required int duration,
  }) async {
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

  // Update topic completion status
  Future<void> updateTopicCompletion(String topicId, bool completed) async {
    try {
      await topicsCollection.doc(topicId).update({
        'completed': completed,
        'updated_at': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('Topic completion status updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating topic completion status: $e');
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
        snapshot.docs.map((doc) => Course.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList()
    );
  }

  // Get a single course by its ID
  Future<Course?> getCourse(String courseId) async {
    try {
      final docSnapshot = await coursesCollection.doc(courseId).get();
      if (docSnapshot.exists) {
        return Course.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching course: $e');
      }
      rethrow;
    }
  }

  // Get topics for a specific course
  Stream<List<Topic>> getTopics(String courseId) {
    return topicsCollection.where('course_id', isEqualTo: courseId).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Topic.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList()
    );
  }

  // Get a single topic by its ID
  Future<Topic?> getTopic(String topicId) async {
    try {
      final docSnapshot = await topicsCollection.doc(topicId).get();
      if (docSnapshot.exists) {
        return Topic.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching topic: $e');
      }
      rethrow;
    }
  }

  // Get assessment results
  Stream<List<AssessmentResult>> getAssessmentResults() {
    return assessmentResultsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => AssessmentResult.fromMap(doc.data() as Map<String, dynamic>)).toList()
    );
  }

  // Save feedback and send email response
  Future<void> submitFeedback(
    String email,
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
        'email': email,
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

      // Call the Firebase Function to send an email response
      await sendEmailResponse(email);

      if (kDebugMode) {
        print('Feedback submitted and email response sent successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting feedback or sending email response: $e');
      }
      rethrow;
    }
  }

  // Send email response using Firebase Functions
  Future<void> sendEmailResponse(String email) async {
    try {
      final HttpsCallable callable = functions.httpsCallable('sendFeedbackEmail'); // Make sure the function name matches your deployed function
      await callable.call(<String, dynamic>{
        'email': email,
      });
    } catch (e) {
      debugPrint('Failed to send email response: $e');
    }
  }

  // Fetch topics by course ID
  Future<List<Topic>> getTopicsByCourse(String courseId) async {
    try {
      final querySnapshot = await topicsCollection
          .where('course_id', isEqualTo: courseId)
          .get();
      return querySnapshot.docs
          .map((doc) => Topic.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching topics by course: $e');
      }
      return [];
    }
  }
}
