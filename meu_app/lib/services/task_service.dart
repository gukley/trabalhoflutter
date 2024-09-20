import 'dart:convert';
import 'package:meu_app/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  Future<void> saveTask(
      String title, String description, String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task newTask =
        Task(title: title, description: description, priority: priority);
    tasks.add(jsonEncode(newTask.toJson()));
    await prefs.setStringList('tasks', tasks);
  }

  Future<List<Task>> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = prefs.getStringList('tasks') ?? [];
    List<Task> tasks = taskStrings
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
    return tasks;
  }

  Future<void> deleteTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    tasks.removeAt(index);
    await prefs.setStringList('tasks', tasks);
  }

  Future<void> editTask(int index, String newTitle, String newDescription,
      String priority, bool isDone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task updatedTask = Task(
        title: newTitle,
        description: newDescription,
        priority: priority,
        isDone: isDone);
    tasks[index] = jsonEncode(updatedTask.toJson());
    await prefs.setStringList('tasks', tasks);
  }
}
