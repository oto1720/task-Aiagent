import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/repositories/task_repository.dart';
import 'package:task_aiagent/core/utils/result.dart';

class CompleteTaskUseCase {
  final TaskRepository _taskRepository;

  CompleteTaskUseCase({required TaskRepository taskRepository})
      : _taskRepository = taskRepository;

  AsyncResult<TaskCompletionResult> execute(String taskId) async {
    // タスクの完了状態を切り替え
    final toggleResult = await _taskRepository.toggleTaskCompletion(taskId);
    if (toggleResult.isFailure) {
      return ResultFailure(toggleResult.failure);
    }

    final completedTask = toggleResult.value;

    // ビジネスルール: タスク完了時の連鎖処理
    if (completedTask.status == TaskStatus.completed) {
      // 1. 依存タスクの自動アクティベーション
      await _activateDependentTasks(completedTask);

      // 2. 完了実績の記録
      final stats = await _calculateCompletionStats(completedTask);

      return Success(TaskCompletionResult(
        completedTask: completedTask,
        completionStats: stats,
        message: _generateCompletionMessage(completedTask, stats),
      ));
    } else {
      // タスクを未完了に戻した場合
      return Success(TaskCompletionResult(
        completedTask: completedTask,
        completionStats: null,
        message: 'タスクを未完了に戻しました',
      ));
    }
  }

  Future<void> _activateDependentTasks(Task completedTask) async {
    // 実装例: 特定のタグを持つタスクを自動でアクティベート
    if (completedTask.description.contains('#依存')) {
      final allTasksResult = await _taskRepository.getAllTasks();
      if (allTasksResult.isSuccess) {
        final dependentTasks = allTasksResult.value
            .where((task) =>
                task.description.contains('${completedTask.title}完了後') &&
                task.status == TaskStatus.upcoming)
            .map((task) => task.copyWith(status: TaskStatus.inProgress))
            .toList();

        if (dependentTasks.isNotEmpty) {
          await _taskRepository.bulkUpdateTasks(dependentTasks);
        }
      }
    }
  }

  Future<TaskCompletionStats> _calculateCompletionStats(Task task) async {
    final allTasksResult = await _taskRepository.getAllTasks();
    if (allTasksResult.isFailure) {
      return TaskCompletionStats(
        totalCompletedToday: 1,
        totalEstimatedTime: task.estimatedMinutes,
        averageCompletionTime: task.estimatedMinutes,
        completionRate: 0.0,
      );
    }

    final today = DateTime.now();
    final todayTasks = allTasksResult.value
        .where((t) => t.updatedAt != null && _isSameDate(t.updatedAt!, today))
        .toList();

    final completedToday = todayTasks
        .where((t) => t.status == TaskStatus.completed)
        .length;

    final totalEstimatedTime = todayTasks
        .where((t) => t.status == TaskStatus.completed)
        .fold<int>(0, (sum, t) => sum + t.estimatedMinutes);

    final totalTasks = todayTasks.length;
    final completionRate = totalTasks > 0 ? completedToday / totalTasks : 0.0;

    return TaskCompletionStats(
      totalCompletedToday: completedToday,
      totalEstimatedTime: totalEstimatedTime,
      averageCompletionTime: completedToday > 0 ? totalEstimatedTime ~/ completedToday : 0,
      completionRate: completionRate,
    );
  }

  String _generateCompletionMessage(Task task, TaskCompletionStats stats) {
    final messages = [
      'タスク「${task.title}」を完了しました！',
      '今日は${stats.totalCompletedToday}個のタスクを完了',
      '合計作業時間: ${stats.totalEstimatedTime}分',
    ];

    if (stats.completionRate >= 0.8) {
      messages.add('素晴らしい進捗です！🎉');
    } else if (stats.completionRate >= 0.5) {
      messages.add('順調に進んでいます！👍');
    }

    return messages.join('\n');
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class TaskCompletionResult {
  final Task completedTask;
  final TaskCompletionStats? completionStats;
  final String message;

  TaskCompletionResult({
    required this.completedTask,
    required this.completionStats,
    required this.message,
  });
}

class TaskCompletionStats {
  final int totalCompletedToday;
  final int totalEstimatedTime;
  final int averageCompletionTime;
  final double completionRate;

  TaskCompletionStats({
    required this.totalCompletedToday,
    required this.totalEstimatedTime,
    required this.averageCompletionTime,
    required this.completionRate,
  });
}