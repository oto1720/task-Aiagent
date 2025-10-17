import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/core/constant/themes.dart';
import 'package:task_aiagent/presentation/features/calendar/components/schedule_block_card.dart';

/// 今日のスケジュールセクションウィジェット
class TodayScheduleSection extends StatelessWidget {
  final DailySchedule? schedule;

  const TodayScheduleSection({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppThemes.primaryBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.schedule_rounded,
                    color: AppThemes.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '今日のスケジュール',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppThemes.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (schedule == null)
              _buildEmptyState()
            else
              Column(
                children: schedule!.blocks.map((block) {
                  return ScheduleBlockCard(block: block);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppThemes.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppThemes.grey200, width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: AppThemes.grey400,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'まだスケジュールが生成されていません',
            style: TextStyle(color: AppThemes.secondaryTextColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
