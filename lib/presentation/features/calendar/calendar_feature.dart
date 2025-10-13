import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/domain/entities/personal_schedule.dart';
import 'package:task_aiagent/presentation/providers/calendar_provider.dart';
import 'package:task_aiagent/presentation/providers/personal_schedule_provider.dart';
import 'package:task_aiagent/presentation/features/calendar/widgets/calendar_widget.dart';
import 'package:task_aiagent/presentation/features/calendar/widgets/calendar_action_bar.dart';
import 'package:task_aiagent/presentation/features/calendar/widgets/calendar_event_list.dart';
import 'package:task_aiagent/presentation/widgets/schedule/personal_schedule_form_dialog.dart';

/// カレンダーフィーチャーメインウィジェット
class CalendarFeature extends ConsumerWidget {
  const CalendarFeature({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // カレンダー表示
        const CalendarWidget(),

        // アクションボタン
        CalendarActionBar(
          onAddSchedule: () => _showScheduleDialog(context, ref),
        ),

        const SizedBox(height: 8.0),

        // イベントリスト
        Expanded(
          child: CalendarEventList(
            onScheduleEdit: (date, schedule) =>
                _showScheduleDialog(context, ref, date, schedule),
            onScheduleDelete: (schedule) =>
                _showDeleteConfirmDialog(context, ref, schedule),
          ),
        ),
      ],
    );
  }

  void _showScheduleDialog(
    BuildContext context,
    WidgetRef ref, [
    DateTime? selectedDate,
    PersonalSchedule? schedule,
  ]) async {
    final effectiveDate = selectedDate ?? ref.read(selectedDayProvider);

    final result = await showDialog<PersonalSchedule>(
      context: context,
      builder: (context) => PersonalScheduleFormDialog(
        selectedDate: effectiveDate ?? DateTime.now(),
        schedule: schedule,
      ),
    );

    if (result != null) {
      if (schedule == null) {
        await ref
            .read(personalScheduleListProvider.notifier)
            .addSchedule(result);
      } else {
        await ref
            .read(personalScheduleListProvider.notifier)
            .updateSchedule(result);
      }
    }
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    PersonalSchedule schedule,
  ) {
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
              await ref
                  .read(personalScheduleListProvider.notifier)
                  .removeSchedule(schedule.id);
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
