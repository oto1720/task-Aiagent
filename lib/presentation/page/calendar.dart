
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/entities/personal_schedule.dart';
import 'package:task_aiagent/presentation/providers/calendar_provider.dart';
import 'package:task_aiagent/presentation/providers/task_providers.dart';
import 'package:task_aiagent/presentation/providers/personal_schedule_provider.dart';
import 'package:task_aiagent/presentation/widgets/schedule/personal_schedule_form_dialog.dart';
import 'package:task_aiagent/core/constant/themes.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Task> _getEventsForDay(DateTime day) {
    final events = ref.watch(calendarEventsProvider);
    final dateKey = DateTime.utc(day.year, day.month, day.day);
    return events[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          _buildCalendar(),
          _buildActionButtons(),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      );
  }

  Widget _buildCalendar() {
    final selectedDay = ref.watch(selectedDayProvider);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: TableCalendar<Task>(
        locale: 'ja_JP',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: selectedDay,
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: (newSelectedDay, newFocusedDay) {
          if (!isSameDay(selectedDay, newSelectedDay)) {
            ref.read(selectedDayProvider.notifier).set(newSelectedDay);
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
           ref.read(selectedDayProvider.notifier).set(focusedDay);
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            if (day.weekday == DateTime.sunday) {
              final text = DateFormat.E('ja_JP').format(day);
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (day.weekday == DateTime.saturday) {
              final text = DateFormat.E('ja_JP').format(day);
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.blue),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final selectedDay = ref.watch(selectedDayProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () => _showScheduleDialog(selectedDay),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('スケジュール追加'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final selectedDay = ref.watch(selectedDayProvider);
    final isToday = isSameDay(selectedDay, DateTime.now());

    if (isToday) {
      return _buildTodaySchedule();
    } else {
      final selectedTasks = ref.watch(tasksForDayProvider(selectedDay));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              '${DateFormat('M月d日 (E)', 'ja_JP').format(selectedDay)} のタスク・スケジュール',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          _buildSelectedDayContent(selectedDay, selectedTasks),
        ],
      );
    }
  }

  Widget _buildTaskTile(BuildContext context, WidgetRef ref, Task task) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.status == TaskStatus.completed,
          onChanged: (_) => ref.read(taskListProvider.notifier).completeTask(task.id),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.status == TaskStatus.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Text('${task.estimatedMinutes}分 · ${task.category}'),
        trailing: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getPriorityColor(task.priority),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return AppThemes.errorColor;
      case TaskPriority.high:
        return AppThemes.primaryOrange;
      case TaskPriority.medium:
        return AppThemes.lightOrange;
      case TaskPriority.low:
        return AppThemes.successColor;
    }
  }

  Widget _buildSelectedDayContent(DateTime selectedDay, List<Task> tasks) {
    final personalSchedules = ref.watch(personalSchedulesForDayProvider(selectedDay));
    final hasAnyContent = tasks.isNotEmpty || personalSchedules.isNotEmpty;

    if (!hasAnyContent) {
      return const Expanded(
        child: Center(
          child: Text('この日のタスク・スケジュールはありません。'),
        ),
      );
    }

    final allItems = <dynamic>[];
    allItems.addAll(tasks);
    allItems.addAll(personalSchedules);

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

    return Expanded(
      child: ListView.builder(
        itemCount: allItems.length,
        itemBuilder: (context, index) {
          final item = allItems[index];
          if (item is Task) {
            return _buildTaskTile(context, ref, item);
          } else if (item is PersonalSchedule) {
            return _buildPersonalScheduleTile(item);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTodaySchedule() {
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (combinedSchedule.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[400], size: 48),
                      const SizedBox(height: 8),
                      Text(
                        'まだスケジュールがありません',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: combinedSchedule.length,
                  itemBuilder: (context, index) {
                    final item = combinedSchedule[index];
                    if (item is ScheduleBlock) {
                      return _buildScheduleBlock(item);
                    } else if (item is PersonalSchedule) {
                      return _buildPersonalScheduleBlock(item);
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

  Widget _buildScheduleBlock(ScheduleBlock block) {
    final startTime = DateFormat('HH:mm').format(block.startTime);
    final endTime = DateFormat('HH:mm').format(block.endTime);

    final priorityColor = _getPriorityColor(block.priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppThemes.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            startTime,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: priorityColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Icon(
                            Icons.arrow_downward_rounded,
                            size: 12,
                            color: priorityColor,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            endTime,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: priorityColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            block.taskTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppThemes.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule_outlined,
                                size: 14,
                                color: AppThemes.secondaryTextColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${block.durationInMinutes}分',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppThemes.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: priorityColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getPriorityText(block.priority),
                        style: TextStyle(
                          fontSize: 11,
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return '高';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.low:
        return '低';
      case TaskPriority.urgent:
        return '緊急';
    }
  }

  Widget _buildPersonalScheduleTile(PersonalSchedule schedule) {
    final startTime = DateFormat('HH:mm').format(schedule.startTime);
    final endTime = DateFormat('HH:mm').format(schedule.endTime);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppThemes.darkOrange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppThemes.darkOrange.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemes.darkOrange.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.event_rounded, color: AppThemes.darkOrange),
        title: Text(
          schedule.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppThemes.textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.schedule_outlined,
                  size: 14,
                  color: AppThemes.secondaryTextColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '$startTime - $endTime (${schedule.durationInMinutes}分)',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppThemes.secondaryTextColor,
                  ),
                ),
              ],
            ),
            if (schedule.description != null && schedule.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                schedule.description!,
                style: const TextStyle(color: AppThemes.secondaryTextColor),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleScheduleAction(action, schedule),
          icon: Icon(Icons.more_vert, color: AppThemes.grey600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, color: AppThemes.primaryOrange, size: 18),
                  const SizedBox(width: 8),
                  const Text('編集'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: AppThemes.errorColor, size: 18),
                  SizedBox(width: 8),
                  Text('削除', style: TextStyle(color: AppThemes.errorColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalScheduleBlock(PersonalSchedule schedule) {
    final startTime = DateFormat('HH:mm').format(schedule.startTime);
    final endTime = DateFormat('HH:mm').format(schedule.endTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppThemes.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemes.darkOrange.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: AppThemes.darkOrange,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      decoration: BoxDecoration(
                        color: AppThemes.darkOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            startTime,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppThemes.darkOrange,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Icon(
                            Icons.arrow_downward_rounded,
                            size: 12,
                            color: AppThemes.darkOrange,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            endTime,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppThemes.darkOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            schedule.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppThemes.textColor,
                            ),
                          ),
                          if (schedule.description != null && schedule.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              schedule.description!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppThemes.secondaryTextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule_outlined,
                                size: 14,
                                color: AppThemes.secondaryTextColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${schedule.durationInMinutes}分',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppThemes.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppThemes.darkOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppThemes.darkOrange.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        '個人',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppThemes.darkOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScheduleDialog(DateTime selectedDate, [PersonalSchedule? schedule]) async {
    final result = await showDialog<PersonalSchedule>(
      context: context,
      builder: (context) => PersonalScheduleFormDialog(
        selectedDate: selectedDate,
        schedule: schedule,
      ),
    );

    if (result != null) {
      if (schedule == null) {
        await ref.read(personalScheduleListProvider.notifier).addSchedule(result);
      } else {
        await ref.read(personalScheduleListProvider.notifier).updateSchedule(result);
      }
    }
  }

  void _handleScheduleAction(String action, PersonalSchedule schedule) {
    switch (action) {
      case 'edit':
        _showScheduleDialog(schedule.date, schedule);
        break;
      case 'delete':
        _showDeleteConfirmDialog(schedule);
        break;
    }
  }

  void _showDeleteConfirmDialog(PersonalSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('スケジュール削除'),
        content: Text('「${schedule.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(personalScheduleListProvider.notifier).removeSchedule(schedule.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}
