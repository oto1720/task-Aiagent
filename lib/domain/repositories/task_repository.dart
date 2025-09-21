import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/core/utils/result.dart';

abstract class TaskRepository {
  AsyncResult<List<Task>> getAllTasks();
  AsyncResult<List<Task>> getActiveTasksSortedByPriority();
  AsyncResult<List<Task>> getTasksForDate(DateTime date);
  AsyncResult<Task> createTask(Task task);
  AsyncResult<Task> updateTask(Task task);
  AsyncResult<void> deleteTask(String taskId);
  AsyncResult<List<Task>> reorderTasks(List<Task> tasks);
  AsyncResult<Task> toggleTaskCompletion(String taskId);
  AsyncResult<List<Task>> bulkUpdateTasks(List<Task> tasks);
}