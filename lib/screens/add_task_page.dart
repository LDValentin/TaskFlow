import 'package:flutter/material.dart';
import '../models/task.dart';
import 'dart:math';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final titleController = TextEditingController();
  final estimatedMinutesController = TextEditingController();

  String selectedCategory = 'Study';
  DateTime? selectedDeadline;

  int difficulty = 3;
  int priority = 3;

  final subjectController = TextEditingController();
  final chaptersController = TextEditingController();
  final cleaningController = TextEditingController();
  final errandsController = TextEditingController();

  Future<void> pickDeadline() async {

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDeadline = picked;
      });
    }
  }

  void saveTask() {

    if (titleController.text.isEmpty ||
        estimatedMinutesController.text.isEmpty ||
        selectedDeadline == null) {
      return;
    }

    final task = Task(
      id: Random().nextDouble().toString(),
      title: titleController.text,
      category: selectedCategory,
      deadline: selectedDeadline!,
      createdAt: DateTime.now(),
      estimatedMinutes: int.parse(estimatedMinutesController.text),
      difficulty: difficulty,
      priority: priority,
      subject: selectedCategory == 'Study'
          ? subjectController.text
          : null,
      chapters: selectedCategory == 'Study'
          ? int.tryParse(chaptersController.text)
          : null,
      cleaningDetails: selectedCategory == 'Cleaning'
          ? cleaningController.text
          : null,
      errandDetails: selectedCategory == 'Errands'
          ? errandsController.text
          : null,
    );

    Navigator.pop(context, task);
  }

  Widget buildCategoryFields() {

    if (selectedCategory == 'Study') {
      return Column(
        children: [
          TextField(
            controller: subjectController,
            decoration: const InputDecoration(
              labelText: 'Subject',
            ),
          ),
          TextField(
            controller: chaptersController,
            decoration: const InputDecoration(
              labelText: 'Chapters',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      );
    }

    if (selectedCategory == 'Cleaning') {
      return TextField(
        controller: cleaningController,
        decoration: const InputDecoration(
          labelText: 'What needs cleaning?',
        ),
      );
    }

    if (selectedCategory == 'Errands') {
      return TextField(
        controller: errandsController,
        decoration: const InputDecoration(
          labelText: 'Errand details',
        ),
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Task"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Task Title',
            ),
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField(
            value: selectedCategory,
            items: const [
              DropdownMenuItem(value: 'Study', child: Text('Study')),
              DropdownMenuItem(value: 'Cleaning', child: Text('Cleaning')),
              DropdownMenuItem(value: 'Errands', child: Text('Errands')),
            ],
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
          ),

          const SizedBox(height: 16),

          buildCategoryFields(),

          const SizedBox(height: 16),

          TextField(
            controller: estimatedMinutesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Estimated Minutes',
            ),
          ),

          const SizedBox(height: 16),

          ListTile(
            title: Text(
              selectedDeadline == null
                  ? "Pick Deadline"
                  : "Deadline: ${selectedDeadline!.toLocal()}".split(' ')[0],
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: pickDeadline,
          ),

          const SizedBox(height: 16),

          Text("Difficulty: $difficulty"),

          Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: difficulty.toDouble(),
            label: difficulty.toString(),
            onChanged: (value) {
              setState(() {
                difficulty = value.toInt();
              });
            },
          ),

          const SizedBox(height: 16),

          Text("Priority: $priority"),

          Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: priority.toDouble(),
            label: priority.toString(),
            onChanged: (value) {
              setState(() {
                priority = value.toInt();
              });
            },
          ),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: saveTask,
            child: const Text("Save Task"),
          )
        ],
      ),
    );
  }
}