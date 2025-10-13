import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/presentation/providers/calendar_provider.dart';

/// カレンダーウィジェット
class CalendarWidget extends ConsumerStatefulWidget {
  const CalendarWidget({super.key});

  @override
  ConsumerState<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends ConsumerState<CalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Task> _getEventsForDay(DateTime day) {
    final events = ref.watch(calendarEventsProvider);
    final dateKey = DateTime.utc(day.year, day.month, day.day);
    return events[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
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
                child: Text(text, style: const TextStyle(color: Colors.red)),
              );
            }
            if (day.weekday == DateTime.saturday) {
              final text = DateFormat.E('ja_JP').format(day);
              return Center(
                child: Text(text, style: const TextStyle(color: Colors.blue)),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
