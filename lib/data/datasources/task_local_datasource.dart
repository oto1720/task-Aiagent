import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/core/error/failures.dart';

abstract class TaskLocalDataSource {
  Future<List<Task>> getAllTasks();
  Future<void> saveTasks(List<Task> tasks);
  Future<void> saveTask(Task task);
  Future<void> deleteTask(String taskId);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String _tasksKey = 'tasks';
  final SharedPreferences _sharedPreferences;

  TaskLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final tasksJson = _sharedPreferences.getString(_tasksKey);
      if (tasksJson == null) return [];

      final List<dynamic> tasksList = json.decode(tasksJson);
      return tasksList.map((taskJson) => Task.fromJson(taskJson)).toList();
    } catch (e) {
      throw CacheFailure('タスクの取得に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
      await _sharedPreferences.setString(_tasksKey, tasksJson);
    } catch (e) {
      throw CacheFailure('タスクの保存に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<void> saveTask(Task task) async {
    try {
      final tasks = await getAllTasks();
      final index = tasks.indexWhere((t) => t.id == task.id);

      if (index != -1) {
        tasks[index] = task;
      } else {
        tasks.add(task);
      }

      await saveTasks(tasks);
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure('タスクの保存に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final tasks = await getAllTasks();
      tasks.removeWhere((task) => task.id == taskId);
      await saveTasks(tasks);
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure('タスクの削除に失敗しました: ${e.toString()}');
    }
  }
}