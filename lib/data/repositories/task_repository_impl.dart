import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/repositories/task_repository.dart';
import 'package:task_aiagent/data/datasources/task_local_datasource.dart';
import 'package:task_aiagent/core/utils/result.dart';
import 'package:task_aiagent/core/error/failures.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;

  TaskRepositoryImpl({required TaskLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  AsyncResult<List<Task>> getAllTasks() async {
    try {
      final tasks = await _localDataSource.getAllTasks();
      return Success(tasks);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(UnexpectedFailure('タスクの取得中に予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<List<Task>> getActiveTasksSortedByPriority() async {
    try {
      final tasks = await _localDataSource.getAllTasks();
      final activeTasks = tasks
          .where((task) => task.status != TaskStatus.completed)
          .toList()
        ..sort(_compareTasksByPriority);
      return Success(activeTasks);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(UnexpectedFailure('アクティブタスクの取得中にエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<List<Task>> getTasksForDate(DateTime date) async {
    try {
      final tasks = await _localDataSource.getAllTasks();
      final dateTasks = tasks.where((task) => _isSameDate(task.dueDate, date)).toList();
      return Success(dateTasks);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(UnexpectedFailure('指定日のタスク取得中にエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<Task> createTask(Task task) async {
    try {
      final validationResult = _validateTask(task);
      if (!validationResult.isValid) {
        return ResultFailure(ValidationFailure(validationResult.errors.join(', ')));
      }

      final enrichedTask = _enrichNewTask(task);
      await _localDataSource.saveTask(enrichedTask);
      return Success(enrichedTask);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(UnexpectedFailure('タスクの作成中にエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<Task> updateTask(Task task) async {
    try {
      final validationResult = _validateTask(task);
      if (!validationResult.isValid) {
        return ResultFailure(ValidationFailure(validationResult.errors.join(', ')));
      }

      final updatedTask = task.copyWith(updatedAt: DateTime.now());
      await _localDataSource.saveTask(updatedTask);
      return Success(updatedTask);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(UnexpectedFailure('タスクの更新中にエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<void> deleteTask(String taskId) async {
    try {
      if (taskId.isEmpty) {
        return ResultFailure(ValidationFailure('タスクIDが無効です'));
      }

      await _localDataSource.deleteTask(taskId);
      return Success(null);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(UnexpectedFailure('タスクの削除中にエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<List<Task>> reorderTasks(List<Task> tasks) async {
    try {
      if (tasks.isEmpty) {
        return Success(tasks);
      }

      final reorderedTasks = <Task>[];
      for (int i = 0; i < tasks.length; i++) {
        final updatedTask = tasks[i].copyWith(
          sortOrder: i,
          updatedAt: DateTime.now(),
        );
        reorderedTasks.add(updatedTask);
      }

      await _localDataSource.saveTasks(reorderedTasks);
      return Success(reorderedTasks);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(UnexpectedFailure('タスクの並び替え中にエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<Task> toggleTaskCompletion(String taskId) async {
    try {
      final tasks = await _localDataSource.getAllTasks();
      final taskIndex = tasks.indexWhere((task) => task.id == taskId);

      if (taskIndex == -1) {
        return ResultFailure(ValidationFailure('指定されたタスクが見つかりません'));
      }

      final task = tasks[taskIndex];
      final newStatus = task.status == TaskStatus.completed
          ? TaskStatus.upcoming
          : TaskStatus.completed;

      final updatedTask = task.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );

      await _localDataSource.saveTask(updatedTask);
      return Success(updatedTask);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(UnexpectedFailure('タスクの完了状態切り替え中にエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<List<Task>> bulkUpdateTasks(List<Task> tasks) async {
    try {
      if (tasks.isEmpty) {
        return Success(tasks);
      }

      for (final task in tasks) {
        final validationResult = _validateTask(task);
        if (!validationResult.isValid) {
          return ResultFailure(ValidationFailure('無効なタスクが含まれています: ${validationResult.errors.join(', ')}'));
        }
      }

      final updatedTasks = tasks.map((task) => task.copyWith(updatedAt: DateTime.now())).toList();
      await _localDataSource.saveTasks(updatedTasks);
      return Success(updatedTasks);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(UnexpectedFailure('タスクの一括更新中にエラーが発生しました: ${e.toString()}'));
    }
  }

  // プライベートヘルパーメソッド
  int _compareTasksByPriority(Task a, Task b) {
    // 優先度でソート（高い方が先）
    final priorityComparison = a.priorityOrder.compareTo(b.priorityOrder);
    if (priorityComparison != 0) return priorityComparison;

    // カスタムソート順
    if (a.sortOrder != null && b.sortOrder != null) {
      return a.sortOrder!.compareTo(b.sortOrder!);
    }

    // 作成日時でソート
    return a.createdAt.compareTo(b.createdAt);
  }

  bool _isSameDate(DateTime? date1, DateTime date2) {
    if (date1 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Task _enrichNewTask(Task task) {
    final now = DateTime.now();
    return task.copyWith(
      createdAt: task.createdAt,
      updatedAt: now,
    );
  }

  TaskValidationResult _validateTask(Task task) {
    final errors = <String>[];

    if (task.title.trim().isEmpty) {
      errors.add('タスク名を入力してください');
    }

    if (task.title.length > 100) {
      errors.add('タスク名は100文字以内で入力してください');
    }

    if (task.estimatedMinutes <= 0) {
      errors.add('所要時間は1分以上で入力してください');
    }

    if (task.estimatedMinutes > 480) {
      errors.add('所要時間は8時間以内で入力してください');
    }

    return TaskValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

class TaskValidationResult {
  final bool isValid;
  final List<String> errors;

  const TaskValidationResult({
    required this.isValid,
    required this.errors,
  });
}