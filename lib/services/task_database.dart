import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class TaskDatabase{
  static final TaskDatabase instance = TaskDatabase.init();
  static Database? _database;

  TaskDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async{
    await db.execute('''
    CREATE TABLE tasks (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    createdAt TEXT NOT NULL,
    deadline TEXT NOT NULL,
    estimatedMinutes INTEGER NOT NULL,
    difficulty INTEGER NOT NULL,
    priority INTEGER NOT NULL,
    isCompleted INTEGER NOT NULL,
    subject TEXT,
    chapters INTEGER,
    cleaningDetails TEXT,
    errandDetails TEXT
    )'''
  );
  }

  Future<void> insertTask(Task task) async{
    final db = await instance.database;
    await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getAllTasks() async{
    final db = await instance.database;
    final result = await db.query('tasks');

    return result.map((map) => Task.fromMap(map)).toList();
  }
  Future<void> updateTask(Task task) async{
    final db = await instance.database;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(String id) async{
    final db = await instance.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> close() async{
    final db = await instance.database;
    db.close();
  }
}