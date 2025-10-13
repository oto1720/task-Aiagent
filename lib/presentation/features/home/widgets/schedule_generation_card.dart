import 'package:flutter/material.dart';
import 'package:task_aiagent/core/constant/themes.dart';

/// スケジュール生成カードウィジェット
class ScheduleGenerationCard extends StatelessWidget {
  final bool hasTask;
  final VoidCallback onGenerateSchedule;

  const ScheduleGenerationCard({
    super.key,
    required this.hasTask,
    required this.onGenerateSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppThemes.darkOrange.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppThemes.paleOrange.withValues(alpha: 0.3),
              AppThemes.paleOrange,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppThemes.darkOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppThemes.darkOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AI時間割生成',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppThemes.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              hasTask
                  ? 'AIがあなたのタスクを分析して、最適な時間割を自動生成します。'
                  : 'タスクを追加してからAI時間割を生成してください。',
              style: const TextStyle(
                color: AppThemes.secondaryTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: hasTask ? onGenerateSchedule : null,
                icon: const Icon(Icons.schedule_rounded),
                label: const Text('今日の時間割を生成'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
