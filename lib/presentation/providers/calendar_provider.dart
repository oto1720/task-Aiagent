import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/domain/entities/personal_schedule.dart';
import 'package:task_aiagent/presentation/providers/task_provider.dart';
import 'package:task_aiagent/presentation/providers/personal_schedule_provider.dart';

part 'calendar_provider.g.dart';

// 選択された日付を管理する NotifierProvider
@riverpod
class SelectedDay extends _$SelectedDay {
  @override
  DateTime build() {
    return DateTime.now();
  }
  void set(DateTime date) {
    // 時刻情報をリセットして日付のみを保持
    state = DateTime.utc(date.year, date.month, date.day);
  }
}

// カレンダーに表示するイベント（タスク）を日付ごとにグループ化して提供する Provider
@riverpod
Map<DateTime, List<Task>> calendarEvents(CalendarEventsRef ref) {
  final tasks = ref.watch(taskListProvider);
  final events = <DateTime, List<Task>>{};

  for (final task in tasks) {
    if (task.dueDate != null) {
      // 時刻情報を無視した日付のみのキー
      final dateKey = DateTime.utc(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
      if (events[dateKey] == null) {
        events[dateKey] = [];
      }
      events[dateKey]!.add(task);
    }
  }
  return events;
}

// 選択された日付のタスクリストを提供する Provider
@riverpod
List<Task> tasksForDay(TasksForDayRef ref, DateTime day) {
  final events = ref.watch(calendarEventsProvider);
  final dateKey = DateTime.utc(day.year, day.month, day.day);
  return events[dateKey] ?? [];
}

// 今日のスケジュール（AI生成）を提供する Provider
@riverpod
DailySchedule? todaySchedule(TodayScheduleRef ref) {
  return null;
}

// 今日の全スケジュール（個人スケジュール＋AI生成スケジュール）を統合して提供する Provider
@riverpod
class CombinedTodaySchedule extends _$CombinedTodaySchedule {
  @override
  List<dynamic> build() {
    final personalSchedules = ref.watch(todayPersonalSchedulesProvider);
    final aiSchedule = ref.watch(todayScheduleProvider);

    final combined = <dynamic>[];

    combined.addAll(personalSchedules);

    if (aiSchedule != null) {
      combined.addAll(aiSchedule.blocks);
    }

    combined.sort((a, b) {
      final aStartTime = a is PersonalSchedule ? a.startTime : (a as ScheduleBlock).startTime;
      final bStartTime = b is PersonalSchedule ? b.startTime : (b as ScheduleBlock).startTime;
      return aStartTime.compareTo(bStartTime);
    });

    return combined;
  }
}
