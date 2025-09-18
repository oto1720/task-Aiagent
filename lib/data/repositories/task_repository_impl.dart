import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/repositories/task_repository.dart';
import 'package:task_aiagent/data/datasources/local/local_storage_service.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalStorageService _localStorageService;

  TaskRepositoryImpl(this._localStorageService);

  @override
  Future<List<Task>> getTasks() async {
    try {
      return await _localStorageService.getTasks();
    } catch (e) {
      print('Error getting tasks: $e');
      return [];
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      await _localStorageService.addTask(task);
    } catch (e) {
      print('Error adding task: $e');
      throw Exception('Failed to add task');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      await _localStorageService.updateTask(task);
    } catch (e) {
      print('Error updating task: $e');
      throw Exception('Failed to update task');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _localStorageService.deleteTask(taskId);
    } catch (e) {
      print('Error deleting task: $e');
      throw Exception('Failed to delete task');
    }
  }

  @override
  Future<void> reorderTasks(List<Task> tasks) async {
    try {
      for (final task in tasks) {
        await _localStorageService.updateTask(task);
      }
    } catch (e) {
      print('Error reordering tasks: $e');
      throw Exception('Failed to reorder tasks');
    }
  }
}