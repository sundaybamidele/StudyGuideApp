class Topic {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final int duration;
  final bool completed;

  Topic({
    required this.id,
    required this.courseId,
    required this.title,
    required this.content,
    required this.duration,
    required this.completed,
  });

  factory Topic.fromFirestore(Map<String, dynamic> data, String id) {
    return Topic(
      id: id,
      courseId: data['course_id'],
      title: data['title'],
      content: data['content'],
      duration: data['duration'],
      completed: data['completed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'course_id': courseId,
      'title': title,
      'content': content,
      'duration': duration,
      'completed': completed,
    };
  }
}
