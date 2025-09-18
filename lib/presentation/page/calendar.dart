
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/presentation/providers/calendar_provider.dart';
import 'package:task_aiagent/presentation/providers/task_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  List<Task> _getEventsForDay(DateTime day) {
    final events = ref.watch(calendarEventsProvider);
    final dateKey = DateTime.utc(day.year, day.month, day.day);
    return events[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 予定追加ダイアログを表示
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: TableCalendar<Task>(
        locale: 'ja_JP',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
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
          _focusedDay = focusedDay;
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

  Widget _buildEventList() {
    final selectedTasks = ref.watch(tasksForDayProvider(_selectedDay));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '${DateFormat('M月d日 (E)', 'ja_JP').format(_selectedDay)} のタスク',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (selectedTasks.isEmpty)
          const Expanded(
            child: Center(
              child: Text('この日のタスクはありません。'),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: selectedTasks.length,
              itemBuilder: (context, index) {
                final task = selectedTasks[index];
                return _buildTaskTile(context, ref, task);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildTaskTile(BuildContext context, WidgetRef ref, Task task) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.status == TaskStatus.completed,
          onChanged: (_) => ref.read(taskListProvider.notifier).toggleTaskStatus(task.id),
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
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}
