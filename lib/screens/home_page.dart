import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_page.dart';
import '../models/recommendation_engine.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Study Biology',
      category: 'Study',
      deadline: DateTime.now().add(const Duration(days: 2)),
      createdAt: DateTime.now(),
      estimatedMinutes: 90,
      difficulty: 4,
      priority: 5,
      subject: 'Biology',
      chapters: 3,
    ),
    Task(
      id: '2',
      title: 'Clean bedroom',
      category: 'Cleaning',
      deadline: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
      estimatedMinutes: 45,
      difficulty: 2,
      priority: 3,
      cleaningDetails: 'Desk, floor, clothes',
    ),
    Task(
      id: '3',
      title: 'Go to the bank',
      category: 'Errands',
      deadline: DateTime.now().add(const Duration(days: 3)),
      createdAt: DateTime.now(),
      estimatedMinutes: 30,
      difficulty: 1,
      priority: 4,
      errandDetails: 'Deposit check',
      isCompleted: true,
    ),
  ];

  void toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  void deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${task.title} deleted'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void onStartPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Start flow coming soon'),
      ),
    );
  }

  Future<void> onAddTaskPressed() async {

  final newTask = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AddTaskPage(),
    ),
  );

  if (newTask != null) {
    setState(() {
      tasks.add(newTask);
    });
  }
}

  void onTaskTap(Task task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Open details for: ${task.title}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = tasks.where((task) => task.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTaskPressed,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStartCard(),
          const SizedBox(height: 20),
          _buildSectionTitle('Pending Tasks'),
          const SizedBox(height: 8),
          if (pendingTasks.isEmpty)
            const _EmptyState(message: 'No pending tasks')
          else
            ...pendingTasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TaskCard(
                  task: task,
                  onTap: () => onTaskTap(task),
                  onToggleComplete: () => toggleTaskCompletion(task),
                  onDelete: () => deleteTask(task),
                ),
              ),
            ),
          const SizedBox(height: 24),
          _buildSectionTitle('Completed Tasks'),
          const SizedBox(height: 8),
          if (completedTasks.isEmpty)
            const _EmptyState(message: 'No completed tasks yet')
          else
            ...completedTasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TaskCard(
                  task: task,
                  onTap: () => onTaskTap(task),
                  onToggleComplete: () => toggleTaskCompletion(task),
                  onDelete: () => deleteTask(task),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStartCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ready to work?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start a session and let the app help you choose what to do first.',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onStartPressed,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
    required this.onDelete,
  });

  String formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => onToggleComplete(),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration:
                  task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            '${task.category} • Due ${formatDate(task.deadline)}\n'
            '${task.estimatedMinutes} min • Difficulty ${task.difficulty} • Priority ${task.priority}',
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}