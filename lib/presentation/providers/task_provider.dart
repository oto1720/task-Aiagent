// lib/presentation/providers/task_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/domain/repositories/task_repository.dart';
import 'package:task_aiagent/data/repositories/task_repository_impl.dart';
import 'package:task_aiagent/data/datasources/local/local_storage_service.dart';
import 'package:task_aiagent/core/service/ai/schedule_generator.dart';
import 'package:task_aiagent/domain/usecases/task/task_management_usecase.dart';

// ローカルストレージサービスのプロバイダー
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final service = LocalStorageService();
  service.init();
  return service;
});

// タスクリポジトリのプロバイダー
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(ref.read(localStorageServiceProvider));
});

// タスク管理ユースケースのプロバイダー
final taskManagementUseCaseProvider = Provider<TaskManagementUseCase>((ref) {
  return TaskManagementUseCase();
});

// スケジュール生成サービスのプロバイダー
final scheduleGeneratorProvider = Provider<ScheduleGeneratorService>((ref) {
  return ScheduleGeneratorService();
});

// タスクリストの状態管理
final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier(
    ref.read(taskRepositoryProvider),
    ref.read(taskManagementUseCaseProvider),
  );
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _taskRepository;
  final TaskManagementUseCase _taskManagement;

  TaskListNotifier(this._taskRepository, this._taskManagement) : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _taskRepository.getTasks();
      state = tasks;
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _taskRepository.addTask(task);
      state = [...state, task];
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    try {
      print('TaskListNotifier.updateTask: ${updatedTask.title}, status=${updatedTask.status}');
      await _taskRepository.updateTask(updatedTask);

      final oldState = state;
      state = state.map((task) {
        return task.id == updatedTask.id ? updatedTask : task;
      }).toList();

      print('Task updated in state. Old count: ${oldState.length}, New count: ${state.length}');
      final updatedTaskInState = state.firstWhere((t) => t.id == updatedTask.id);
      print('Updated task in state: ${updatedTaskInState.title}, status=${updatedTaskInState.status}');
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepository.deleteTask(taskId);
      state = state.where((task) => task.id != taskId).toList();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    final newStatus = task.status == TaskStatus.completed
        ? TaskStatus.upcoming
        : TaskStatus.completed;

    await updateTask(task.copyWith(status: newStatus));
  }

  // ユースケースを使用したメソッド群
  List<Task> getSortedTasks() => _taskManagement.getSortedTasks(state);
  List<Task> getTodayTasks() => _taskManagement.getTodayTasks(state);
  List<Task> getUpcomingTasks() => _taskManagement.getUpcomingTasks(state);
  List<Task> getCompletedTasks() => _taskManagement.getCompletedTasks(state);

  // タスクの並び順を更新
  Future<void> reorderTasks(List<Task> reorderedTasks) async {
    try {
      await _taskRepository.reorderTasks(reorderedTasks);
      await _loadTasks(); // データを再読み込み
    } catch (e) {
      print('Error reordering tasks: $e');
    }
  }
}

// 今日のスケジュールの状態管理
final todayScheduleProvider = StateNotifierProvider<ScheduleNotifier, DailySchedule?>((ref) {
  return ScheduleNotifier(
    ref.read(localStorageServiceProvider),
    ref.read(scheduleGeneratorProvider),
    ref.read(taskListProvider.notifier),
  );
});

class ScheduleNotifier extends StateNotifier<DailySchedule?> {
  final LocalStorageService _storageService;
  final ScheduleGeneratorService _scheduleGenerator;
  final TaskListNotifier _taskNotifier;

  ScheduleNotifier(
    this._storageService,
    this._scheduleGenerator,
    this._taskNotifier,
  ) : super(null) {
    _loadTodaySchedule();
  }

  Future<void> _loadTodaySchedule() async {
    try {
      final today = DateTime.now();
      final schedule = await _storageService.getScheduleForDate(today);
      state = schedule;
    } catch (e) {
      print('Error loading schedule: $e');
    }
  }

  Future<void> generateTodaySchedule() async {
    try {
      final today = DateTime.now();
      final tasks = _taskNotifier.state;
      
      final schedule = await _scheduleGenerator.generateSchedule(tasks, today);
      await _storageService.addSchedule(schedule);
      
      state = schedule;
    } catch (e) {
      print('Error generating schedule: $e');
    }
  }

  Future<void> refreshSchedule() async {
    await generateTodaySchedule();
  }
}

// これからのタスク
final upcomingTasksProvider = Provider<List<Task>>((ref) {
  final notifier = ref.read(taskListProvider.notifier);
  return notifier.getUpcomingTasks();
});

// 今日のタスク
final todayTasksProvider = Provider<List<Task>>((ref) {
  final notifier = ref.read(taskListProvider.notifier);
  return notifier.getTodayTasks();
});

// 完了済みタスク
final completedTasksProvider = Provider<List<Task>>((ref) {
  final notifier = ref.read(taskListProvider.notifier);
  return notifier.getCompletedTasks();
});

// フィルタリングされたタスク（完了済みを除外）
final pendingTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskListProvider);
  return tasks.where((task) => task.status != TaskStatus.completed).toList();
});

// タスクの統計情報
final taskStatsProvider = Provider<Map<String, int>>((ref) {
  final tasks = ref.watch(taskListProvider);
  final taskManagement = ref.read(taskManagementUseCaseProvider);

  return taskManagement.calculateTaskStats(tasks);
});
