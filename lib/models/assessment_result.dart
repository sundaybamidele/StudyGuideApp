import 'package:cloud_firestore/cloud_firestore.dart';

class AssessmentResult {
  final int score;
  final DateTime timestamp;
  // Additional fields as needed

  AssessmentResult({
    required this.score,
    required this.timestamp,
    // Initialize additional fields
  });

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'timestamp': timestamp,
      // Convert additional fields
    };
  }

  factory AssessmentResult.fromMap(Map<String, dynamic> map) {
    return AssessmentResult(
      score: map['score'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      // Initialize additional fields
    );
  }
}
