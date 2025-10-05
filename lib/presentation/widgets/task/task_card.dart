import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/usecases/task/task_formatting_usecase.dart';
import 'package:task_aiagent/core/constant/themes.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onStatusToggle;
  final VoidCallback? onComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onStatusToggle,
    this.onComplete,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = TaskFormattingUseCase();

    return Card(
      key: ValueKey(task.id),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getPriorityBorderColor(),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPriorityIndicator(formatter),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.status == TaskStatus.completed
                              ? TextDecoration.lineThrough
                              : null,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: task.status == TaskStatus.completed
                              ? AppThemes.grey400
                              : AppThemes.textColor,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppThemes.secondaryTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _buildQuickActions(context),
              ],
            ),
            const SizedBox(height: 12),
            _buildMetadata(formatter),
          ],
        ),
      ),
    );
  }

  Color _getPriorityBorderColor() {
    switch (task.priority) {
      case TaskPriority.urgent:
        return Colors.red.shade400;
      case TaskPriority.high:
        return AppThemes.primaryOrange;
      case TaskPriority.medium:
        return AppThemes.lightOrange;
      case TaskPriority.low:
        return AppThemes.grey300;
    }
  }

  Widget _buildPriorityIndicator(TaskFormattingUseCase formatter) {
    final indicatorData = formatter.getPriorityIndicatorData(task.priority);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: indicatorData.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: indicatorData.color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Icon(
        indicatorData.icon,
        color: indicatorData.color,
        size: 22,
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: AppThemes.grey600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: AppThemes.primaryOrange, size: 20),
              const SizedBox(width: 12),
              const Text('編集'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: AppThemes.errorColor, size: 20),
              const SizedBox(width: 12),
              const Text('削除'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetadata(TaskFormattingUseCase formatter) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        // 所要時間
        _buildMetadataChip(
          icon: Icons.schedule_outlined,
          label: formatter.formatEstimatedTime(task.estimatedMinutes),
          color: AppThemes.primaryOrange,
        ),
        // 期日
        if (task.dueDate != null)
          _buildMetadataChip(
            icon: Icons.event_outlined,
            label: formatter.formatDueDate(task.dueDate!),
            color: formatter.getDueDateColor(task),
            isBold: task.isOverdue,
          ),
        // ステータスチップ
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildMetadataChip({
    required IconData icon,
    required String label,
    required Color color,
    bool isBold = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (task.status) {
      case TaskStatus.upcoming:
        statusColor = Colors.blue.shade600;
        statusIcon = Icons.schedule;
        statusLabel = 'これから';
        break;
      case TaskStatus.inProgress:
        statusColor = AppThemes.primaryOrange;
        statusIcon = Icons.play_arrow;
        statusLabel = '進行中';
        break;
      case TaskStatus.completed:
        statusColor = AppThemes.successColor;
        statusIcon = Icons.check_circle;
        statusLabel = '完了';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 6),
          Text(
            statusLabel,
            style: TextStyle(
              color: statusColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}