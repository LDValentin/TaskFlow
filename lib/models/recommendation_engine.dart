import 'package:TaskFlow/models/task.dart';

class RecommendationEngine {

  static double urgencyScore(Task task) {
    final now = DateTime.now();
    final hoursLeft = task.deadline.difference(now).inHours;

    if (hoursLeft <= 0) return 1.0;
    if (hoursLeft <= 24) return 0.9;
    if (hoursLeft <= 72) return 0.7;
    if (hoursLeft <= 168) return 0.5;

    return 0.2;
  }

  static double priorityScore(Task task) {
    return task.priority / 5.0;
  }

  static double energyFitScore(Task task, int energy) {
    return 1 - ((energy - task.difficulty).abs() / 4);
  }

  static double ageScore(Task task) {
    final now = DateTime.now();
    final daysOld = now.difference(task.createdAt).inDays;

    if (daysOld >= 14) return 1.0;

    return daysOld / 14;
  }

  static double timeFitScore(Task task, int timeAvailable) {

    final ratio = task.estimatedMinutes / timeAvailable;

    if (ratio <= 1.0) return 1.0;
    if (ratio <= 1.2) return 0.7;
    if (ratio <= 1.5) return 0.4;

    return 0.0;
  }

  static double computeTaskScore(
    Task task,
    int timeAvailable,
    int energy,
  ) {

    final urgency = urgencyScore(task);
    final priority = priorityScore(task);
    final timeFit = timeFitScore(task, timeAvailable);
    final energyFit = energyFitScore(task, energy);
    final age = ageScore(task);

    return
        0.30 * urgency +
        0.20 * priority +
        0.25 * timeFit +
        0.15 * energyFit +
        0.10 * age;
  }

static List<Task> rankTasks(
  List<Task> tasks,
  int timeAvailable,
  int energy,
) {
  final activeTasks = tasks.where((task) =>
      !task.isCompleted &&
      task.estimatedMinutes <= timeAvailable * 2);

  final scored = activeTasks.map((task) {
    return MapEntry(
      task,
      computeTaskScore(task, timeAvailable, energy),
    );
  }).toList();

  scored.sort((a, b) => b.value.compareTo(a.value));

  return scored.map((entry) => entry.key).toList();
}
}