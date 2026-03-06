class Task{
  final String id;
  String title;
  String category;
  DateTime createdAt;
  DateTime deadline;
  int estimatedMinutes;
  int difficulty; // 1-5
  int priority; // 1-5
  bool isCompleted;

  String? subject;
  int? chapters;
  String? cleaningDetails;
  String? errandDetails;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
    required this.deadline,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.priority,
    this.isCompleted = false,
    this.subject,
    this.chapters,
    this.cleaningDetails,
    this.errandDetails,
  });
}