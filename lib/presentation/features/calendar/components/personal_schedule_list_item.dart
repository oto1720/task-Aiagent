import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/domain/entities/personal_schedule.dart';
import 'package:task_aiagent/core/constant/themes.dart';
import 'package:task_aiagent/presentation/shared/components/time_info_chip.dart';

/// 個人スケジュールリストアイテムコンポーネント
class PersonalScheduleListItem extends StatelessWidget {
  final PersonalSchedule schedule;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PersonalScheduleListItem({
    super.key,
    required this.schedule,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final startTime = DateFormat('HH:mm').format(schedule.startTime);
    final endTime = DateFormat('HH:mm').format(schedule.endTime);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppThemes.darkBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppThemes.darkBlue.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemes.darkBlue.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.event_rounded, color: AppThemes.darkBlue),
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
            TimeInfoChip(
              timeText:
                  '$startTime - $endTime (${schedule.durationInMinutes}分)',
            ),
            if (schedule.description != null &&
                schedule.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                schedule.description!,
                style: const TextStyle(color: AppThemes.secondaryTextColor),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            if (action == 'edit' && onEdit != null) {
              onEdit!();
            } else if (action == 'delete' && onDelete != null) {
              onDelete!();
            }
          },
          icon: Icon(Icons.more_vert, color: AppThemes.grey600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: AppThemes.primaryBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text('編集'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: AppThemes.errorColor,
                    size: 18,
                  ),
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
}
