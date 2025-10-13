import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/presentation/providers/task_providers.dart';
import 'package:task_aiagent/presentation/providers/schedule_providers.dart';
import 'package:task_aiagent/presentation/features/home/widgets/date_header.dart';
import 'package:task_aiagent/presentation/features/home/widgets/stats_cards.dart';
import 'package:task_aiagent/presentation/features/home/widgets/schedule_generation_card.dart';
import 'package:task_aiagent/presentation/features/home/widgets/today_schedule_section.dart';
import 'package:task_aiagent/presentation/features/home/widgets/upcoming_tasks_section.dart';

/// ホームフィーチャーメインウィジェット
class HomeFeature extends ConsumerWidget {
  const HomeFeature({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskStats = ref.watch(taskStatsProvider);
    final todayScheduleAsync = ref.watch(todayScheduleProvider);
    final pendingTasks = ref.watch(activeTasksProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 今日の日付と挨拶
          const DateHeader(),
          const SizedBox(height: 20),

          // タスク統計カード
          StatsCards(stats: taskStats),
          const SizedBox(height: 20),

          // AIスケジュール生成ボタン
          ScheduleGenerationCard(
            hasTask: pendingTasks.isNotEmpty,
            onGenerateSchedule: () => _generateSchedule(context, ref),
          ),
          const SizedBox(height: 20),

          // 今日のスケジュール
          todayScheduleAsync.when(
            data: (todaySchedule) =>
                TodayScheduleSection(schedule: todaySchedule),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('エラー: $error')),
          ),
          const SizedBox(height: 20),

          // 近日中のタスク
          UpcomingTasksSection(tasks: pendingTasks),
        ],
      ),
    );
  }

  Future<void> _generateSchedule(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('AI時間割を生成中...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      await ref.read(todayScheduleProvider.notifier).generateTodaySchedule();
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('時間割を生成しました！'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
