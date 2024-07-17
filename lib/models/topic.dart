class Topic {
  final String title;
  final String content;
  final String courseId;

  Topic({required this.title, required this.content, required this.courseId, required int duration, required String id});

  get studyDuration => null;

  String? get id => null;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'course_id': courseId,
    };
  }

  static Topic fromFirestore(Map<String, dynamic> data, String id) {
    return Topic(
      title: data['title'],
      content: data['content'],
      courseId: data['course_id'],
      duration: data['duration'] ?? 0, id: '',
    );
  }
}
//