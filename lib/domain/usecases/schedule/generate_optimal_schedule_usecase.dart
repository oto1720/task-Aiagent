import 'dart:math' as math;
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/domain/repositories/task_repository.dart';
import 'package:task_aiagent/core/utils/result.dart';
import 'package:task_aiagent/core/error/failures.dart';

class GenerateOptimalScheduleUseCase {
  final TaskRepository _taskRepository;

  GenerateOptimalScheduleUseCase({required TaskRepository taskRepository})
      : _taskRepository = taskRepository;

  AsyncResult<DailySchedule> execute({
    required DateTime targetDate,
    int workingHoursPerDay = 8,
    int breakIntervalMinutes = 60,
    int breakDurationMinutes = 15,
  }) async {
    // 1. 対象日のタスクを取得
    final tasksResult = await _taskRepository.getActiveTasksSortedByPriority();
    if (tasksResult.isFailure) {
      return ResultFailure(tasksResult.failure);
    }

    final allTasks = tasksResult.value;

    // 2. ビジネスルール: スケジュール生成の制約
    final validationResult = _validateScheduleGeneration(
      allTasks,
      workingHoursPerDay * 60,
    );

    if (!validationResult.isValid) {
      return ResultFailure(ValidationFailure(validationResult.error));
    }

    // 3. AI最適化アルゴリズム適用
    final optimizedSchedule = _generateOptimalSchedule(
      allTasks,
      targetDate,
      workingHoursPerDay * 60,
      breakIntervalMinutes,
      breakDurationMinutes,
    );

    return Success(optimizedSchedule);
  }

  ScheduleValidationResult _validateScheduleGeneration(
    List<Task> tasks,
    int availableMinutes,
  ) {
    // ビジネスルール1: 緊急タスクの優先処理
    final urgentTasks = tasks.where((task) => task.priority == TaskPriority.urgent).toList();
    final urgentTasksTime = urgentTasks.fold<int>(0, (sum, task) => sum + task.estimatedMinutes);

    if (urgentTasksTime > availableMinutes * 0.6) {
      return ScheduleValidationResult(
        isValid: false,
        error: '緊急タスクが作業時間の60%を超過しています。タスクの見直しが必要です。',
      );
    }

    // ビジネスルール2: 総作業時間の妥当性
    final totalWorkTime = tasks.fold<int>(0, (sum, task) => sum + task.estimatedMinutes);
    if (totalWorkTime > availableMinutes * 1.2) {
      return ScheduleValidationResult(
        isValid: false,
        error: '予定されている作業時間が利用可能時間を大幅に超過しています。',
      );
    }

    // ビジネスルール3: 集中力を要するタスクの時間分散
    final focusIntensiveTasks = tasks
        .where((task) => task.estimatedMinutes > 120) // 2時間以上
        .toList();

    if (focusIntensiveTasks.length > 2) {
      return ScheduleValidationResult(
        isValid: false,
        error: '長時間集中を要するタスクは1日2個まで推奨されます。',
      );
    }

    return ScheduleValidationResult(isValid: true, error: '');
  }

  DailySchedule _generateOptimalSchedule(
    List<Task> tasks,
    DateTime targetDate,
    int availableMinutes,
    int breakInterval,
    int breakDuration,
  ) {
    final scheduleItems = <ScheduleItem>[];
    var currentTime = DateTime(targetDate.year, targetDate.month, targetDate.day, 9, 0); // 9:00開始
    var remainingMinutes = availableMinutes;
    var consecutiveWorkTime = 0;

    // 優先度ベースのタスク分類
    final urgentTasks = tasks.where((task) => task.priority == TaskPriority.urgent).toList();
    final highTasks = tasks.where((task) => task.priority == TaskPriority.high).toList();
    final mediumTasks = tasks.where((task) => task.priority == TaskPriority.medium).toList();
    final lowTasks = tasks.where((task) => task.priority == TaskPriority.low).toList();

    // ビジネスルール適用: 最適な順序でタスクを配置
    final orderedTasks = [
      ...urgentTasks, // 朝の集中力が高い時間に緊急タスク
      ...highTasks,   // 午前中に重要タスク
      ...mediumTasks, // 午後に中優先度タスク
      ...lowTasks,    // 終日に低優先度タスク
    ];

    for (final task in orderedTasks) {
      if (remainingMinutes <= 0) break;

      // 休憩が必要かチェック
      if (consecutiveWorkTime >= breakInterval && remainingMinutes > task.estimatedMinutes + breakDuration) {
        scheduleItems.add(ScheduleItem(
          id: 'break_${scheduleItems.length}',
          title: '休憩',
          startTime: currentTime,
          endTime: currentTime.add(Duration(minutes: breakDuration)),
          type: ScheduleItemType.breakTime,
        ));

        currentTime = currentTime.add(Duration(minutes: breakDuration));
        remainingMinutes -= breakDuration;
        consecutiveWorkTime = 0;
      }

      // タスクの配置
      final taskDuration = math.min(task.estimatedMinutes, remainingMinutes);

      scheduleItems.add(ScheduleItem(
        id: task.id,
        title: task.title,
        description: task.description,
        startTime: currentTime,
        endTime: currentTime.add(Duration(minutes: taskDuration)),
        type: ScheduleItemType.task,
        priority: task.priority,
        estimatedMinutes: taskDuration,
      ));

      currentTime = currentTime.add(Duration(minutes: taskDuration));
      remainingMinutes -= taskDuration;
      consecutiveWorkTime += taskDuration;
    }

    return DailySchedule(
      id: 'schedule_${targetDate.millisecondsSinceEpoch}',
      date: targetDate,
      blocks: [], // 後方互換性のため空のリスト
      items: scheduleItems,
      totalWorkingMinutes: availableMinutes - remainingMinutes,
      createdAt: DateTime.now(),
    );
  }
}

class ScheduleValidationResult {
  final bool isValid;
  final String error;

  ScheduleValidationResult({
    required this.isValid,
    required this.error,
  });
}