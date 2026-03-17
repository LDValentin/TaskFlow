import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_page.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  String formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _editTask(BuildContext context) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(existingTask: task),
      ),
    );

    if (!context.mounted) return;

    if (updatedTask != null) {
      Navigator.pop(context, updatedTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Category: ${task.category}'),
                  Text('Deadline: ${formatDate(task.deadline)}'),
                  Text('Estimated minutes: ${task.estimatedMinutes}'),
                  Text('Difficulty: ${task.difficulty}'),
                  Text('Priority: ${task.priority}'),
                  Text('Completed: ${task.isCompleted ? "Yes" : "No"}'),
                  const SizedBox(height: 16),

                  if (task.category == 'Study') ...[
                    Text('Subject: ${task.subject ?? "-"}'),
                    Text('Chapters: ${task.chapters?.toString() ?? "-"}'),
                  ],

                  if (task.category == 'Cleaning') ...[
                    Text('Cleaning details: ${task.cleaningDetails ?? "-"}'),
                  ],

                  if (task.category == 'Errands') ...[
                    Text('Errand details: ${task.errandDetails ?? "-"}'),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _editTask(context),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Task'),
          ),
        ],
      ),
    );
  }
}