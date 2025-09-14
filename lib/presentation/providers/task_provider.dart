// lib/presentation/providers/task_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/data/datasources/local/local_storage_service.dart';
import 'package:task_aiagent/core/service/ai/schedule_generator.dart';

// ローカルストレージサービスのプロバイダー
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final service = LocalStorageService();
  service.init();
  return service;
});

// スケジュール生成サービスのプロバイダー
final scheduleGeneratorProvider = Provider<ScheduleGeneratorService>((ref) {
  return ScheduleGeneratorService();
});

// タスクリストの状態管理
final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier(ref.read(localStorageServiceProvider));
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  final LocalStorageService _storageService;

  TaskListNotifier(this._storageService) : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _storageService.getTasks();
      state = tasks;
    } catch (e) {
      // エラーログ出力
      print('Error loading tasks: $e');
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _storageService.addTask(task);
      state = [...state, task];
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    try {
      await _storageService.updateTask(updatedTask);
      state = state.map((task) {
        return task.id == updatedTask.id ? updatedTask : task;
      }).toList();
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _storageService.deleteTask(taskId);
      state = state.where((task) => task.id != taskId).toList();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    final newStatus = task.status == TaskStatus.completed 
        ? TaskStatus.pending 
        : TaskStatus.completed;
    
    await updateTask(task.copyWith(status: newStatus));
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

// フィルタリングされたタスク（完了済みを除外）
final pendingTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskListProvider);
  return tasks.where((task) => task.status != TaskStatus.completed).toList();
});

// 完了済みタスク
final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskListProvider);
  return tasks.where((task) => task.status == TaskStatus.completed).toList();
});

// タスクの統計情報
final taskStatsProvider = Provider<Map<String, int>>((ref) {
  final tasks = ref.watch(taskListProvider);
  
  return {
    'total': tasks.length,
    'pending': tasks.where((t) => t.status == TaskStatus.pending).length,
    'inProgress': tasks.where((t) => t.status == TaskStatus.inProgress).length,
    'completed': tasks.where((t) => t.status == TaskStatus.completed).length,
  };
});