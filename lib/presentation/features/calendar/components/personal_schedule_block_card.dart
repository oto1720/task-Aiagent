import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/domain/entities/personal_schedule.dart';
import 'package:task_aiagent/core/constant/themes.dart';
import 'package:task_aiagent/presentation/shared/components/time_info_chip.dart';

/// 個人スケジュールブロックカードコンポーネント
class PersonalScheduleBlockCard extends StatelessWidget {
  final PersonalSchedule schedule;

  const PersonalScheduleBlockCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
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
                    _buildTimeColumn(startTime, endTime),
                    const SizedBox(width: 12),
                    Expanded(child: _buildScheduleInfo()),
                    _buildTypeLabel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String startTime, String endTime) {
    return Container(
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
    );
  }

  Widget _buildScheduleInfo() {
    return Column(
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
        if (schedule.description != null &&
            schedule.description!.isNotEmpty) ...[
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
        TimeInfoChip(timeText: '${schedule.durationInMinutes}分'),
      ],
    );
  }

  Widget _buildTypeLabel() {
    return Container(
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
    );
  }
}
