// lib/services/ai/schedule_generator.dartzw
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';

class ScheduleGeneratorService {
  static const int _workingStartHour = 9; // 9:00 AM
  static const int _workingEndHour = 17;   // 5:00 PM
  static const int _breakDurationMinutes = 15;
  static const int _maxContinuousWorkMinutes = 90;

  /// タスクリストから最適化されたスケジュールを生成
  Future<DailySchedule> generateSchedule(
    List<Task> tasks, 
    DateTime targetDate
  ) async {
    // 完了済みタスクを除外し、優先度でソート
    final pendingTasks = tasks
        .where((task) => task.status != TaskStatus.completed)
        .toList();
    
    _sortTasksByPriority(pendingTasks);

    final scheduleBlocks = <ScheduleBlock>[];
    var currentTime = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      _workingStartHour,
    );

    var continuousWorkMinutes = 0;

    for (final task in pendingTasks) {
      // 作業時間の上限をチェック
      if (currentTime.hour >= _workingEndHour) break;

      // 連続作業時間が上限に達した場合は休憩を挿入
      if (continuousWorkMinutes >= _maxContinuousWorkMinutes) {
        currentTime = currentTime.add(Duration(minutes: _breakDurationMinutes));
        continuousWorkMinutes = 0;
      }

      // タスクを最適なサイズに分割
      final taskDuration = _optimizeTaskDuration(task.estimatedMinutes);
      final endTime = currentTime.add(Duration(minutes: taskDuration));

      // 終業時間を超える場合はスキップ
      if (endTime.hour > _workingEndHour) continue;

      final scheduleBlock = ScheduleBlock(
        taskId: task.id,
        startTime: currentTime,
        endTime: endTime,
        taskTitle: task.title,
        priority: task.priority,
      );

      scheduleBlocks.add(scheduleBlock);
      currentTime = endTime;
      continuousWorkMinutes += taskDuration;
    }

    return DailySchedule(
      date: targetDate,
      blocks: scheduleBlocks,
    );
  }

  /// タスクを優先度と推定時間で最適にソート
  void _sortTasksByPriority(List<Task> tasks) {
    tasks.sort((a, b) {
      // 優先度を最初の基準とする
      final priorityComparison = b.priority.index.compareTo(a.priority.index);
      if (priorityComparison != 0) return priorityComparison;

      // 同じ優先度の場合は短いタスクを優先
      return a.estimatedMinutes.compareTo(b.estimatedMinutes);
    });
  }

  /// タスクの実行時間を最適化（集中力を考慮）
  int _optimizeTaskDuration(int estimatedMinutes) {
    // ポモドーロテクニック基準：25分単位で調整
    if (estimatedMinutes <= 25) return estimatedMinutes;
    if (estimatedMinutes <= 50) return 25; // 最初の25分だけ実行
    if (estimatedMinutes <= 90) return 45; // 45分で区切る
    return 60; // 最大60分で区切る
  }

  /// ユーザーの行動パターンに基づく学習的最適化（将来の拡張用）
  Future<DailySchedule> generateOptimizedSchedule(
    List<Task> tasks,
    DateTime targetDate, {
    Map<String, dynamic>? userPreferences,
    List<DailySchedule>? pastSchedules,
  }) async {
    // 基本スケジュール生成
    var schedule = await generateSchedule(tasks, targetDate);

    // ユーザー設定による調整
    if (userPreferences != null) {
      schedule = _adjustForUserPreferences(schedule, userPreferences);
    }

    // 過去のパフォーマンスデータによる調整
    if (pastSchedules != null && pastSchedules.isNotEmpty) {
      schedule = _adjustBasedOnPastPerformance(schedule, pastSchedules);
    }

    return schedule;
  }

  DailySchedule _adjustForUserPreferences(
    DailySchedule schedule,
    Map<String, dynamic> preferences,
  ) {
    // 例：ユーザーが朝型か夜型かによる調整
    final isMorningPerson = preferences['isMorningPerson'] ?? true;
    //final preferredBreakDuration = preferences['breakDuration'] ?? 15;

    if (!isMorningPerson) {
      // 夜型の人は午後に重要なタスクを配置
      // ここでは簡略化
    }

    return schedule;
  }

  DailySchedule _adjustBasedOnPastPerformance(
    DailySchedule schedule,
    List<DailySchedule> pastSchedules,
  ) {
    // 過去のデータから学習した最適化を適用
    // 例：特定の時間帯の生産性が高い場合、重要なタスクをその時間に配置
    return schedule;
  }
}