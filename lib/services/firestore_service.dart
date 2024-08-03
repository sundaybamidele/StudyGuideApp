import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import for local notifications
import 'package:timezone/timezone.dart' as tz; // Import for timezone
import '../models/course.dart';
import '../models/topic.dart';
import '../models/assessment_result.dart'; // Import the assessment result model
import '../models/user.dart'; // Import the user profile model

class FirestoreService {
  final CollectionReference coursesCollection = FirebaseFirestore.instance.collection('courses');
  final CollectionReference topicsCollection = FirebaseFirestore.instance.collection('topics');
  final CollectionReference assessmentResultsCollection = FirebaseFirestore.instance.collection('assessment_results'); // New collection for assessment results
  final CollectionReference feedbackCollection = FirebaseFirestore.instance.collection('feedback'); // New collection for feedback
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users'); // Collection for user profiles
  final FirebaseFunctions functions = FirebaseFunctions.instance; // Initialize Firebase Functions

  // Initialize FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FirestoreService() {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

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
        'usefulness_rating': usefulnessRating,
        'usage_frequency': usageFrequency,
        'grades_improvement': gradesImprovement,
        'navigation_ease_rating': navigationEaseRating,
        'satisfaction_rating': satisfactionRating,
        'organization_effect': organizationEffect,
        'content_quality_rating': contentQualityRating,
        'recommendation': recommendation,
        'suggestions': suggestions,
        'additional_comments': additionalComments,
        'submitted_at': FieldValue.serverTimestamp(),
      });

      // Sending feedback via Cloud Functions
      try {
        await functions.httpsCallable('sendFeedbackEmail').call({
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
        });
        if (kDebugMode) {
          print('Feedback email sent successfully');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error sending feedback email: $e');
        }
        rethrow;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting feedback: $e');
      }
      rethrow;
    }
  }

  // Create or update a user profile
  Future<void> updateUserProfile(UserProfile userProfile) async {
    try {
      await usersCollection.doc(userProfile.uid).set(userProfile.toMap(), SetOptions(merge: true));
      if (kDebugMode) {
        print('User profile updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user profile: $e');
      }
      rethrow;
    }
  }

  // Get a single user profile by UID
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final docSnapshot = await usersCollection.doc(uid).get();
      if (docSnapshot.exists) {
        return UserProfile.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
      rethrow;
    }
  }

  // Get all user profiles
  Stream<List<UserProfile>> getAllUserProfiles() {
    return usersCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserProfile.fromMap(doc.data() as Map<String, dynamic>)).toList()
    );
  }

  // Helper method to schedule notifications
  Future<void> scheduleNotification(int id, String title, String body, int minutes) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'Your Channel Name',
            channelDescription: 'Your channel description',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      if (kDebugMode) {
        print('Notification scheduled successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling notification: $e');
      }
      rethrow;
    }
  }
}
