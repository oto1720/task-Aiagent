import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/repositories/task_repository.dart';
import 'package:task_aiagent/core/utils/result.dart';
import 'package:task_aiagent/core/error/failures.dart';

class CreateTaskUseCase {
  final TaskRepository _taskRepository;

  CreateTaskUseCase({required TaskRepository taskRepository})
      : _taskRepository = taskRepository;

  AsyncResult<Task> execute({
    required String title,
    required String description,
    required int estimatedMinutes,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {
    // ビジネスルール1: 重複するタスクの検証
    final existingTasksResult = await _taskRepository.getAllTasks();
    if (existingTasksResult.isFailure) {
      return ResultFailure(existingTasksResult.failure);
    }

    final existingTasks = existingTasksResult.value;
    final isDuplicate = existingTasks.any((task) =>
        task.title.toLowerCase().trim() == title.toLowerCase().trim() &&
        task.status != TaskStatus.completed);

    if (isDuplicate) {
      return ResultFailure(ValidationFailure('同じ名前の未完了タスクが既に存在します'));
    }

    // ビジネスルール2: 一日の総作業時間制限（8時間）
    if (dueDate != null) {
      final dayTasksResult = await _taskRepository.getTasksForDate(dueDate);
      if (dayTasksResult.isFailure) {
        return ResultFailure(dayTasksResult.failure);
      }

      final dayTasks = dayTasksResult.value;
      final totalMinutesForDay = dayTasks
          .where((task) => task.status != TaskStatus.completed)
          .fold<int>(0, (sum, task) => sum + task.estimatedMinutes);

      if (totalMinutesForDay + estimatedMinutes > 480) { // 8時間
        return ResultFailure(ValidationFailure(
            '指定日の作業時間が制限（8時間）を超過します。現在: ${totalMinutesForDay}分, 追加: ${estimatedMinutes}分'));
      }
    }

    // ビジネスルール3: 高優先度タスクの数制限
    if (priority == TaskPriority.urgent) {
      final urgentTasksCount = existingTasks
          .where((task) =>
              task.priority == TaskPriority.urgent &&
              task.status != TaskStatus.completed)
          .length;

      if (urgentTasksCount >= 3) {
        return ResultFailure(ValidationFailure('緊急タスクは同時に3個まで設定できます'));
      }
    }

    // 新しいタスクを作成
    final newTask = Task(
      id: _generateTaskId(),
      title: title.trim(),
      description: description.trim(),
      estimatedMinutes: estimatedMinutes,
      priority: priority,
      status: TaskStatus.upcoming,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await _taskRepository.createTask(newTask);
  }

  String _generateTaskId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}