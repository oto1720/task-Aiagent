import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/entities/personal_schedule.dart';
import 'package:task_aiagent/presentation/providers/calendar_provider.dart';

import 'package:task_aiagent/presentation/providers/personal_schedule_provider.dart';
import 'package:task_aiagent/presentation/features/calendar/components/schedule_block_card.dart';
import 'package:task_aiagent/presentation/features/calendar/components/personal_schedule_block_card.dart';
import 'package:task_aiagent/presentation/features/calendar/components/task_list_item.dart';
import 'package:task_aiagent/presentation/features/calendar/components/personal_schedule_list_item.dart';
import 'package:task_aiagent/presentation/features/calendar/components/empty_schedule_state.dart';

/// カレンダーイベントリストウィジェット
class CalendarEventList extends ConsumerWidget {
  final Function(DateTime, PersonalSchedule?) onScheduleEdit;
  final Function(PersonalSchedule) onScheduleDelete;

  const CalendarEventList({
    super.key,
    required this.onScheduleEdit,
    required this.onScheduleDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final isToday = isSameDay(selectedDay, DateTime.now());

    if (isToday) {
      return _buildTodaySchedule(context, ref);
    } else {
      return _buildSelectedDayContent(context, ref, selectedDay);
    }
  }

  Widget _buildTodaySchedule(BuildContext context, WidgetRef ref) {
    final combinedSchedule = ref.watch(combinedTodayScheduleProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.schedule, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  '今日のスケジュール',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (combinedSchedule.isEmpty)
              const Expanded(child: EmptyScheduleState())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: combinedSchedule.length,
                  itemBuilder: (context, index) {
                    final item = combinedSchedule[index];
                    if (item is ScheduleBlock) {
                      return ScheduleBlockCard(block: item);
                    } else if (item is PersonalSchedule) {
                      return PersonalScheduleBlockCard(schedule: item);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDayContent(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDay,
  ) {
    final selectedTasks = ref.watch(tasksForDayProvider(selectedDay));
    final personalSchedules = ref.watch(
      personalSchedulesForDayProvider(selectedDay),
    );
    final hasAnyContent =
        selectedTasks.isNotEmpty || personalSchedules.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '${DateFormat('M月d日 (E)', 'ja_JP').format(selectedDay)} のタスク・スケジュール',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (!hasAnyContent)
          const Expanded(
            child: EmptyScheduleState(message: 'この日のタスク・スケジュールはありません。'),
          )
        else
          Expanded(child: _buildCombinedList(selectedTasks, personalSchedules)),
      ],
    );
  }

  Widget _buildCombinedList(
    List<Task> tasks,
    List<PersonalSchedule> schedules,
  ) {
    final allItems = <dynamic>[];
    allItems.addAll(tasks);
    allItems.addAll(schedules);

    allItems.sort((a, b) {
      if (a is Task && b is PersonalSchedule) {
        if (a.dueDate != null) {
          return a.dueDate!.compareTo(b.startTime);
        }
        return -1;
      } else if (a is PersonalSchedule && b is Task) {
        if (b.dueDate != null) {
          return a.startTime.compareTo(b.dueDate!);
        }
        return 1;
      } else if (a is PersonalSchedule && b is PersonalSchedule) {
        return a.startTime.compareTo(b.startTime);
      }
      return 0;
    });

    return ListView.builder(
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        if (item is Task) {
          return TaskListItem(task: item);
        } else if (item is PersonalSchedule) {
          return PersonalScheduleListItem(
            schedule: item,
            onEdit: () => onScheduleEdit(item.date, item),
            onDelete: () => onScheduleDelete(item),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
