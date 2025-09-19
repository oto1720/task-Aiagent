import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/presentation/providers/task_provider.dart';

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
