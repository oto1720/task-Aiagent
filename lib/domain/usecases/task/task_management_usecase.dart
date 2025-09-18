import 'package:task_aiagent/domain/entities/task.dart';

class TaskManagementUseCase {
  // タスクの優先度でソートされたリストを取得
  List<Task> getSortedTasks(List<Task> tasks) {
    final sortedTasks = [...tasks];
    sortedTasks.sort((a, b) {
      // 1. 完了状態で分離
      if (a.status == TaskStatus.completed && b.status != TaskStatus.completed) {
        return 1;
      }
      if (a.status != TaskStatus.completed && b.status == TaskStatus.completed) {
        return -1;
      }

      // 2. 優先度でソート
      final priorityComparison = a.priorityOrder.compareTo(b.priorityOrder);
      if (priorityComparison != 0) {
        return priorityComparison;
      }

      // 3. カスタムソート順
      if (a.sortOrder != null && b.sortOrder != null) {
        return a.sortOrder!.compareTo(b.sortOrder!);
      }

      // 4. 作成日時でソート
      return a.createdAt.compareTo(b.createdAt);
    });

    return sortedTasks;
  }

  // これからのタスクを取得
  List<Task> getUpcomingTasks(List<Task> tasks) {
    return tasks.where((task) =>
      task.status == TaskStatus.upcoming && !task.isDueToday
    ).toList();
  }

  // 進行中のタスクを取得
  List<Task> getInProgressTasks(List<Task> tasks) {
    return tasks.where((task) =>
      task.status != TaskStatus.completed && (task.status == TaskStatus.inProgress || task.isDueToday)
    ).toList();
  }

  // 今日のタスクを取得
  List<Task> getTodayTasks(List<Task> tasks) {
    return tasks.where((task) =>
      task.isToday ||
      task.status == TaskStatus.inProgress ||
      task.isDueToday
    ).toList();
  }

  // 完了済みタスクを取得
  List<Task> getCompletedTasks(List<Task> tasks) {
    return tasks.where((task) => task.status == TaskStatus.completed)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 新しい順
  }

  // タスクの検索・フィルタリング
  List<Task> filterTasks(List<Task> tasks, String query) {
    if (query.isEmpty) return tasks;

    final lowerQuery = query.toLowerCase();
    return tasks.where((task) {
      return task.title.toLowerCase().contains(lowerQuery) ||
          task.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // タスクの統計情報を計算
  Map<String, int> calculateTaskStats(List<Task> tasks) {
    return {
      'total': tasks.length,
      'upcoming': tasks.where((t) => t.status == TaskStatus.upcoming).length,
      'inProgress': tasks.where((t) => t.status == TaskStatus.inProgress).length,
      'completed': tasks.where((t) => t.status == TaskStatus.completed).length,
      'today': tasks.where((t) => t.isToday || t.isDueToday).length,
      'overdue': tasks.where((t) => t.isOverdue && t.status != TaskStatus.completed).length,
    };
  }

  // タスクのステータスを変更
  Task toggleTaskStatus(Task task, TaskStatus newStatus) {
    return task.copyWith(status: newStatus);
  }

  // タスクを完了状態に切り替え
  Task toggleCompletion(Task task) {
    final newStatus = task.status == TaskStatus.completed
        ? TaskStatus.upcoming
        : TaskStatus.completed;
    return task.copyWith(status: newStatus);
  }

  // タスクの並び順を更新
  List<Task> updateTaskOrder(List<Task> tasks, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    final reorderedTasks = [...tasks];
    final task = reorderedTasks.removeAt(oldIndex);
    reorderedTasks.insert(newIndex, task);

    // ソート順を更新
    for (int i = 0; i < reorderedTasks.length; i++) {
      reorderedTasks[i] = reorderedTasks[i].copyWith(sortOrder: i);
    }

    return reorderedTasks;
  }

  // バリデーション: タスクの作成・更新時の検証
  ValidationResult validateTask({
    required String title,
    required int estimatedMinutes,
  }) {
    final errors = <String>[];

    if (title.trim().isEmpty) {
      errors.add('タスク名を入力してください');
    }

    if (estimatedMinutes <= 0) {
      errors.add('所要時間は1分以上で入力してください');
    }

    if (estimatedMinutes > 480) { // 8時間
      errors.add('所要時間は8時間以内で入力してください');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  const ValidationResult({
    required this.isValid,
    required this.errors,
  });
}