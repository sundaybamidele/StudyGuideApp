class Topic {
  final String id;
  final String title;
  final String content;
  final String courseId;
  final int studyDuration; // Duration in minutes

  Topic({required this.id, required this.title, required this.content, required this.courseId, required this.studyDuration, required int duration});

  get duration => null;

  get options => null;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'course_id': courseId,
      'duration': studyDuration,
    };
  }

  static Topic fromFirestore(Map<String, dynamic> data, String id) {
    return Topic(
      id: id,
      title: data['title'],
      content: data['content'],
      courseId: data['course_id'],
      studyDuration: data['duration'] ?? 0,
      duration: data['duration'] ?? 0,
    );
  }
}
