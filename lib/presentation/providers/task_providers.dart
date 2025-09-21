
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/repositories/task_repository.dart';
import 'package:task_aiagent/domain/usecases/task/create_task_usecase.dart';
import 'package:task_aiagent/domain/usecases/task/complete_task_usecase.dart';
import 'package:task_aiagent/data/repositories/task_repository_impl.dart';
import 'package:task_aiagent/data/datasources/task_local_datasource.dart';

part 'task_providers.g.dart';

// Infrastructure層のプロバイダー
@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

// Data層のプロバイダー
@riverpod
TaskLocalDataSource taskLocalDataSource(Ref ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return sharedPrefs.when(
    data: (prefs) => TaskLocalDataSourceImpl(sharedPreferences: prefs),
    loading: () => throw Exception('SharedPreferences not ready'),
    error: (error, stack) => throw error,
  );
}

@riverpod
TaskRepository taskRepository(Ref ref) {
  final dataSource = ref.watch(taskLocalDataSourceProvider);
  return TaskRepositoryImpl(localDataSource: dataSource);
}

// UseCase層のプロバイダー
@riverpod
CreateTaskUseCase createTaskUseCase(Ref ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return CreateTaskUseCase(taskRepository: repository);
}

@riverpod
CompleteTaskUseCase completeTaskUseCase(Ref ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return CompleteTaskUseCase(taskRepository: repository);
}

// 状態管理のプロバイダー（AsyncNotifierを使用）
@riverpod
class TaskList extends _$TaskList {
  @override
  Future<List<Task>> build() async {
    // buildメソッドでは副作用を発生させず、初期データの読み込みのみ
    final repository = ref.watch(taskRepositoryProvider);
    final result = await repository.getAllTasks();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (tasks) => tasks,
    );
  }

  Future<void> createTask({
    required String title,
    required String description,
    required int estimatedMinutes,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {
    final createUseCase = ref.read(createTaskUseCaseProvider);

    final result = await createUseCase.execute(
      title: title,
      description: description,
      estimatedMinutes: estimatedMinutes,
      priority: priority,
      dueDate: dueDate,
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (task) {
        // 成功時は状態を更新
        state.whenData((currentTasks) {
          state = AsyncValue.data([...currentTasks, task]);
        });
      },
    );
  }

  Future<void> updateTask(Task task) async {
    final repository = ref.read(taskRepositoryProvider);

    final result = await repository.updateTask(task);

    result.fold(
      (failure) => throw Exception(failure.message),
      (updatedTask) {
        state.whenData((currentTasks) {
          final updatedList = currentTasks.map((t) =>
            t.id == updatedTask.id ? updatedTask : t
          ).toList();
          state = AsyncValue.data(updatedList);
        });
      },
    );
  }

  Future<void> deleteTask(String taskId) async {
    final repository = ref.read(taskRepositoryProvider);

    final result = await repository.deleteTask(taskId);

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) {
        state.whenData((currentTasks) {
          final updatedList = currentTasks.where((task) => task.id != taskId).toList();
          state = AsyncValue.data(updatedList);
        });
      },
    );
  }

  Future<void> completeTask(String taskId) async {
    final completeUseCase = ref.read(completeTaskUseCaseProvider);

    final result = await completeUseCase.execute(taskId);

    result.fold(
      (failure) => throw Exception(failure.message),
      (completionResult) {
        state.whenData((currentTasks) {
          final updatedList = currentTasks.map((task) =>
            task.id == taskId ? completionResult.completedTask : task
          ).toList();
          state = AsyncValue.data(updatedList);

          // 完了メッセージの通知（ここでSnackBarやToastを表示する処理を呼び出し）
          _showCompletionMessage(completionResult.message);
        });
      },
    );
  }

  Future<void> reorderTasks(List<Task> reorderedTasks) async {
    final repository = ref.read(taskRepositoryProvider);

    final result = await repository.reorderTasks(reorderedTasks);

    result.fold(
      (failure) => throw Exception(failure.message),
      (tasks) => state = AsyncValue.data(tasks),
    );
  }

  void _showCompletionMessage(String message) {
    // 実装は presentation 層で処理
    // 例: ref.read(notificationServiceProvider).showMessage(message);
  }
}

// 計算されたプロバイダー（他のプロバイダーに依存）
@riverpod
List<Task> activeTasks(Ref ref) {
  final taskList = ref.watch(taskListProvider);
  return taskList.when(
    data: (tasks) => tasks.where((task) => task.status != TaskStatus.completed).toList(),
    loading: () => [],
    error: (error, stack) => [],
  );
}

@riverpod
List<Task> completedTasks(Ref ref) {
  final taskList = ref.watch(taskListProvider);
  return taskList.when(
    data: (tasks) => tasks
        .where((task) => task.status == TaskStatus.completed)
        .toList()
      ..sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!)),
    loading: () => [],
    error: (error, stack) => [],
  );
}

@riverpod
List<Task> todayTasks(Ref ref) {
  final taskList = ref.watch(taskListProvider);
  final today = DateTime.now();

  return taskList.when(
    data: (tasks) => tasks.where((task) {
      if (task.dueDate == null) return false;
      final dueDate = task.dueDate!;
      return dueDate.year == today.year &&
          dueDate.month == today.month &&
          dueDate.day == today.day;
    }).toList(),
    loading: () => [],
    error: (error, stack) => [],
  );
}

@riverpod
List<Task> urgentTasks(Ref ref) {
  final activeTasks = ref.watch(activeTasksProvider);
  return activeTasks
      .where((task) => task.priority == TaskPriority.urgent)
      .toList();
}

@riverpod
Map<String, int> taskStats(Ref ref) {
  final taskList = ref.watch(taskListProvider);

  return taskList.when(
    data: (tasks) => {
      'total': tasks.length,
      'active': tasks.where((t) => t.status != TaskStatus.completed).length,
      'completed': tasks.where((t) => t.status == TaskStatus.completed).length,
      'urgent': tasks.where((t) =>
          t.priority == TaskPriority.urgent &&
          t.status != TaskStatus.completed).length,
      'today': tasks.where((t) {
        if (t.dueDate == null) return false;
        final today = DateTime.now();
        final dueDate = t.dueDate!;
        return dueDate.year == today.year &&
            dueDate.month == today.month &&
            dueDate.day == today.day;
      }).length,
    },
    loading: () => {
      'total': 0,
      'active': 0,
      'completed': 0,
      'urgent': 0,
      'today': 0,
    },
    error: (error, stack) => {
      'total': 0,
      'active': 0,
      'completed': 0,
      'urgent': 0,
      'today': 0,
    },
  );
}