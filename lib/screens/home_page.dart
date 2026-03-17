import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_page.dart';
import '../models/recommendation_engine.dart';
import 'task_detail_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController timeController = TextEditingController();
  int selectedEnergy = 3;

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
  timeController.clear();
  selectedEnergy = 3;

  showDialog(
    context: context,
    builder: (startDialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Start Session'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Time available (minutes)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Energy: $selectedEnergy'),
                Slider(
                  min: 1,
                  max: 5,
                  divisions: 4,
                  value: selectedEnergy.toDouble(),
                  label: selectedEnergy.toString(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedEnergy = value.toInt();
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(startDialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final timeAvailable =
                      int.tryParse(timeController.text.trim());

                  if (timeAvailable == null || timeAvailable <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid time.'),
                      ),
                    );
                    return;
                  }

                  final rankedTasks = RecommendationEngine.rankTasks(
                    tasks,
                    timeAvailable,
                    selectedEnergy,
                  );

                  Navigator.of(startDialogContext).pop();

                  if (!mounted) return;

                  if (rankedTasks.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (emptyDialogContext) => AlertDialog(
                        title: const Text('No task found'),
                        content: const Text(
                          'No available tasks match your current time and energy.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(emptyDialogContext).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  final bestTask = rankedTasks.first;
                  final topAlternatives = rankedTasks.skip(1).take(2).toList();

                  showDialog(
                    context: context,
                    builder: (resultDialogContext) => AlertDialog(
                      title: const Text('Recommended Task'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bestTask.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Category: ${bestTask.category}'),
                          Text(
                            'Estimated time: ${bestTask.estimatedMinutes} min',
                          ),
                          Text('Difficulty: ${bestTask.difficulty}'),
                          Text('Priority: ${bestTask.priority}'),
                          const SizedBox(height: 16),
                          if (topAlternatives.isNotEmpty) ...[
                            const Text(
                              'Top alternatives:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...topAlternatives.map(
                              (task) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text('• ${task.title}'),
                              ),
                            ),
                          ],
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(resultDialogContext).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Recommend'),
              ),
            ],
          );
        },
      );
    },
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

  Future<void> onTaskTap(Task task) async {
  final updatedTask = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaskDetailPage(task: task),
    ),
  );

  if (updatedTask != null && updatedTask is Task) {
    setState(() {
      final index = tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
    });
  }
}

  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
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