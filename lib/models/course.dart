import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String title;
  final String description;

  Course({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Course.fromFirestore(DocumentSnapshot doc, [String? id]) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw const FormatException('Invalid data format for Course');
    }

    return Course(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}
