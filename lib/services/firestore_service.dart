import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';
import '../models/topic.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference coursesCollection = FirebaseFirestore.instance.collection('courses');
  final CollectionReference topicsCollection = FirebaseFirestore.instance.collection('topics');
  final CollectionReference assessmentsCollection = FirebaseFirestore.instance.collection('assessments');
  final CollectionReference studyGuidesCollection = FirebaseFirestore.instance.collection('study_guides');
  final CollectionReference enrollmentsCollection = FirebaseFirestore.instance.collection('enrollments');
  final CollectionReference notesCollection = FirebaseFirestore.instance.collection('notes');

  // Create a new course
  Future<void> createCourse(String title, String description) async {
    try {
      await coursesCollection.add({
        'title': title,
        'description': description,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
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
    } catch (e) {
      print(e);
    }
  }

  // Create a new assessment
  Future<void> createAssessment(String courseId, String title, String type, List<Map<String, dynamic>> questions) async {
    try {
      await assessmentsCollection.add({
        'course_id': courseId,
        'title': title,
        'type': type,
        'questions': questions,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
    }
  }

  // Create a new study guide
  Future<void> createStudyGuide(String courseId, List<String> topics, String title, String content) async {
    try {
      await studyGuidesCollection.add({
        'course_id': courseId,
        'topics': topics,
        'title': title,
        'content': content,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
    }
  }

  // Enroll a user in a course
  Future<void> enrollUser(String userId, String courseId) async {
    try {
      await enrollmentsCollection.add({
        'user_id': userId,
        'course_id': courseId,
        'enrolled_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
    }
  }

  // Create a new note
  Future<void> createNote(String userId, String courseId, String topicId, String content) async {
    try {
      await notesCollection.add({
        'user_id': userId,
        'course_id': courseId,
        'topic_id': topicId,
        'content': content,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
    }
  }

  // Get all courses
  Stream<List<Course>> getCourses() {
    return coursesCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Course.fromFirestore(doc as Map<String, dynamic>))
        .toList());
  }

  // Get topics for a specific course
  Stream<List<Topic>> getTopics(String courseId) {
    return topicsCollection.where('course_id', isEqualTo: courseId).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Topic.fromFirestore(doc as Map<String, dynamic>))
        .toList());
  }

  addCourse(Course newCourse) {}

  addTopic(String courseId, Topic newTopic) {}

  deleteReminder(String s, String t) {}
}
