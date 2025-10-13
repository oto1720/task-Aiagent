import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/core/constant/themes.dart';
import 'package:task_aiagent/presentation/shared/components/priority_indicator.dart';
import 'package:task_aiagent/presentation/shared/components/time_info_chip.dart';

/// スケジュールブロックカードコンポーネント
class ScheduleBlockCard extends StatelessWidget {
  final ScheduleBlock block;

  const ScheduleBlockCard({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final startTime = DateFormat('HH:mm').format(block.startTime);
    final endTime = DateFormat('HH:mm').format(block.endTime);
    final priorityColor = PriorityIndicator.getPriorityColor(block.priority);

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
            // 左側の優先度インジケーターバー
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
                    // 時間表示部分
                    _buildTimeColumn(startTime, endTime, priorityColor),
                    const SizedBox(width: 12),
                    // タスク情報部分
                    Expanded(child: _buildTaskInfo()),
                    // 優先度ラベル
                    PriorityIndicator(
                      priority: block.priority,
                      showLabel: true,
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

  Widget _buildTimeColumn(String startTime, String endTime, Color color) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Icon(Icons.arrow_downward_rounded, size: 12, color: color),
          const SizedBox(height: 2),
          Text(
            endTime,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInfo() {
    return Column(
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
        TimeInfoChip(timeText: '${block.durationInMinutes}分'),
      ],
    );
  }
}
