import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/core/constant/themes.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/domain/entities/task.dart';

/// AIスケジュールセクション
///
/// AI生成された1日のタスクスケジュールを時系列で表示
class AiScheduleSection extends StatelessWidget {
  final List<ScheduleItem> scheduleItems;
  final Function(ScheduleItem)? onItemCompleted;

  const AiScheduleSection({
    super.key,
    required this.scheduleItems,
    this.onItemCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // セクションヘッダー
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: AppThemes.primaryBlue,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              '今日のAIスケジュール',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppThemes.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // スケジュールアイテムリスト
        if (scheduleItems.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: scheduleItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = scheduleItems[index];
              final isCurrentItem = _isCurrentItem(item);

              return ScheduleItemCard(
                item: item,
                isCurrentItem: isCurrentItem,
                onCompleted: onItemCompleted != null
                    ? () => onItemCompleted!(item)
                    : null,
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppThemes.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemes.grey300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 64,
            color: AppThemes.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            'スケジュールがまだ生成されていません',
            style: TextStyle(
              fontSize: 16,
              color: AppThemes.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '下のボタンからAIスケジュールを生成してください',
            style: TextStyle(
              fontSize: 13,
              color: AppThemes.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _isCurrentItem(ScheduleItem item) {
    final now = DateTime.now();
    return now.isAfter(item.startTime) && now.isBefore(item.endTime);
  }
}

/// スケジュールアイテムカード
class ScheduleItemCard extends StatefulWidget {
  final ScheduleItem item;
  final bool isCurrentItem;
  final VoidCallback? onCompleted;

  const ScheduleItemCard({
    super.key,
    required this.item,
    this.isCurrentItem = false,
    this.onCompleted,
  });

  @override
  State<ScheduleItemCard> createState() => _ScheduleItemCardState();
}

class _ScheduleItemCardState extends State<ScheduleItemCard> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final startTime = timeFormat.format(widget.item.startTime);
    final endTime = timeFormat.format(widget.item.endTime);

    return Container(
      decoration: BoxDecoration(
        color: _isCompleted
            ? AppThemes.grey100
            : widget.isCurrentItem
                ? AppThemes.primaryBlue.withValues(alpha: 0.1)
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isCurrentItem
              ? AppThemes.primaryBlue
              : _getTypeColor().withValues(alpha: 0.3),
          width: widget.isCurrentItem ? 2 : 1,
        ),
        boxShadow: widget.isCurrentItem
            ? [
                BoxShadow(
                  color: AppThemes.primaryBlue.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onCompleted,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 時間表示
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        startTime,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getTypeColor(),
                        ),
                      ),
                      Icon(
                        Icons.arrow_downward,
                        size: 12,
                        color: _getTypeColor(),
                      ),
                      Text(
                        endTime,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getTypeColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // タスク情報
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getTypeIcon(),
                            size: 16,
                            color: _getTypeColor(),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.item.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _isCompleted
                                    ? AppThemes.grey600
                                    : AppThemes.textColor,
                                decoration: _isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.item.durationInMinutes}分',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppThemes.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // 完了チェックボックス
                Checkbox(
                  value: _isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _isCompleted = value ?? false;
                    });
                    if (_isCompleted && widget.onCompleted != null) {
                      widget.onCompleted!();
                    }
                  },
                  activeColor: _getTypeColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (widget.item.type) {
      case ScheduleItemType.task:
        return _getPriorityColor(widget.item.priority);
      case ScheduleItemType.breakTime:
        return AppThemes.successColor;
      case ScheduleItemType.meeting:
        return AppThemes.darkBlue;
      case ScheduleItemType.other:
        return AppThemes.grey600;
    }
  }

  Color _getPriorityColor(TaskPriority? priority) {
    if (priority == null) return AppThemes.primaryBlue;

    switch (priority) {
      case TaskPriority.urgent:
        return AppThemes.errorColor;
      case TaskPriority.high:
        return Color(0xFFFF6B6B);
      case TaskPriority.medium:
        return AppThemes.primaryBlue;
      case TaskPriority.low:
        return AppThemes.lightBlue;
    }
  }

  IconData _getTypeIcon() {
    switch (widget.item.type) {
      case ScheduleItemType.task:
        return Icons.assignment_outlined;
      case ScheduleItemType.breakTime:
        return Icons.coffee_outlined;
      case ScheduleItemType.meeting:
        return Icons.people_outline;
      case ScheduleItemType.other:
        return Icons.more_horiz;
    }
  }
}
