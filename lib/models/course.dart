class Course {
  final String id;
  final String title;
  final String description;

  Course({this.id = '', required this.title, required this.description});

  factory Course.fromFirestore(Map<String, dynamic> data) {
    return Course(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
