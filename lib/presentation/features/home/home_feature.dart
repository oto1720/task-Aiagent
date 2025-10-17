import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/presentation/providers/task_providers.dart';
import 'package:task_aiagent/presentation/providers/schedule_providers.dart';
import 'package:task_aiagent/presentation/providers/timer/timer_providers.dart';
import 'package:task_aiagent/presentation/features/home/widgets/greeting_header.dart';
import 'package:task_aiagent/presentation/features/home/widgets/ai_schedule_section.dart';
import 'package:task_aiagent/presentation/features/home/widgets/active_timer_section.dart';
import 'package:task_aiagent/core/constant/themes.dart';
import 'package:task_aiagent/domain/entities/timer.dart';

/// ホームフィーチャーメインウィジェット
class HomeFeature extends ConsumerWidget {
  const HomeFeature({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayScheduleAsync = ref.watch(todayScheduleProvider);
    final currentScheduleItem = ref.watch(currentScheduleItemProvider);
    final timer = ref.watch(timerProvider);
    final pendingTasks = ref.watch(activeTasksProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppThemes.paleBlue.withValues(alpha: 0.1),
            Colors.white,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 動的な挨拶ヘッダー
            GreetingHeader(
              userName: '田中',
              aiHint: _getDailyHint(),
            ),
            const SizedBox(height: 20),

            // 実行中のタイマーセクション
            ActiveTimerSection(
              timer: timer.value,
              currentTaskName: currentScheduleItem?.title,
              onStart: () => _startTimer(ref),
              onPause: () => ref.read(timerProvider.notifier).pause(),
              onResume: () => ref.read(timerProvider.notifier).resume(),
              onPrevious: null, // 実装可能
              onNext: () => ref.read(timerProvider.notifier).nextTimer(),
            ),
            const SizedBox(height: 20),

            // AIスケジュールセクション
            todayScheduleAsync.when(
              data: (todaySchedule) => AiScheduleSection(
                scheduleItems: todaySchedule?.items ?? [],
                onItemCompleted: (item) {
                  // タスク完了処理
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => AiScheduleSection(
                scheduleItems: const [],
              ),
            ),
            const SizedBox(height: 20),

            // フッター：スケジュール再生成ボタン
            _buildFooter(context, ref, pendingTasks.isNotEmpty),
          ],
        ),
      ),
    );
  }

  /// 日替わりヒントを取得
  String _getDailyHint() {
    final hints = [
      '午前中は集中力が高まる時間帯です。重要なタスクから始めましょう。',
      '集中力を高めるために、25分作業・5分休憩のリズムを試してみましょう。',
      '休憩を忘れずに取りましょう。短い休憩が生産性を向上させます。',
      'タスクを小さく分割すると、取り組みやすくなります。',
      '今日も一歩ずつ、着実に進めていきましょう。',
      '完璧を目指すより、まず行動することが大切です。',
      '適度な運動や深呼吸で、集中力をリフレッシュしましょう。',
    ];

    // 日付に基づいてヒントを選択（日替わり）
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return hints[dayOfYear % hints.length];
  }

  /// タイマーを開始
  Future<void> _startTimer(WidgetRef ref) async {
    final timer = ref.read(timerProvider).value;

    if (timer == null) {
      // タイマーが存在しない場合、新しいポモドーロタイマーを作成
      await ref.read(timerProvider.notifier).createTimer(
            type: TimerType.pomodoro,
          );
      await ref.read(timerProvider.notifier).start();
    } else {
      // 既存のタイマーを開始
      await ref.read(timerProvider.notifier).start();
    }
  }

  /// フッター（スケジュール再生成ボタン）
  Widget _buildFooter(BuildContext context, WidgetRef ref, bool hasTask) {
    return Column(
      children: [
        // スケジュール再生成ボタン
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: hasTask
                ? () => _generateSchedule(context, ref)
                : null,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('スケジュールを再生成'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemes.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: AppThemes.grey300,
              disabledForegroundColor: AppThemes.grey600,
            ),
          ),
        ),
        if (!hasTask) ...[
          const SizedBox(height: 8),
          Text(
            'タスクを追加してからスケジュールを生成してください',
            style: TextStyle(
              fontSize: 13,
              color: AppThemes.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 16),

        // 今日のタスク追加リンク
        TextButton.icon(
          onPressed: () {
            // タスク追加画面に遷移
            // GoRouterを使用している場合は context.go('/tasks') など
          },
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('今日のタスクを追加'),
          style: TextButton.styleFrom(
            foregroundColor: AppThemes.darkBlue,
          ),
        ),
      ],
    );
  }

  Future<void> _generateSchedule(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: AppThemes.primaryBlue,
                ),
                const SizedBox(height: 20),
                const Text(
                  'AI時間割を生成中...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('時間割を生成しました！'),
              ],
            ),
            backgroundColor: AppThemes.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('エラーが発生しました: $e')),
              ],
            ),
            backgroundColor: AppThemes.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}
