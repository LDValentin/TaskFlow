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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'estimatedMinutes': estimatedMinutes,
      'difficulty': difficulty,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
      'subject': subject,
      'chapters': chapters,
      'cleaningDetails': cleaningDetails,
      'errandDetails': errandDetails,
    };
  }
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
      deadline: DateTime.parse(map['deadline']),
      estimatedMinutes: map['estimatedMinutes'],
      difficulty: map['difficulty'],
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
      subject: map['subject'],
      chapters: map['chapters'],
      cleaningDetails: map['cleaningDetails'],
      errandDetails: map['errandDetails'],
    );
  }
}