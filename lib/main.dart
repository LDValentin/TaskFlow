import 'package:flutter/material.dart';
import 'models/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TaskPage(),
    );
  }
}
class TaskPage extends StatefulWidget{
  const TaskPage({super.key});
  @override
  State<TaskPage> createState() => _TaskPageState();
  
}

class _TaskPageState extends State<TaskPage>{
  final List<Task> tasks = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDueDate;

  void addTask(){
    if(titleController.text.isEmpty || descriptionController.text.isEmpty || selectedDueDate == null){
      return;
    }
    setState(() {
      tasks.add(Task(
        title: titleController.text,
        description: descriptionController.text,
        dueDate: selectedDueDate!,
      ));
      titleController.clear();
      descriptionController.clear();
      selectedDueDate = null;
    });
  }
  void toggleTaskCompletion(int index){
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }
  Future<void> selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                Row(
                  children: [
                    Text(selectedDueDate == null
                        ? 'No due date selected'
                        : 'Due Date: ${selectedDueDate!.toLocal()}'.split(' ')[0]),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => selectDueDate(context),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: addTask,
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text('${task.description}\nDue: ${task.dueDate.toLocal()}'.split(' ')[0]),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) => toggleTaskCompletion(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
