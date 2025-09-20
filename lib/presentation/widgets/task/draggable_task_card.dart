import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/usecases/task/task_formatting_usecase.dart';

class DraggableTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onStatusToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DraggableTaskCard({
    super.key,
    required this.task,
    this.onStatusToggle,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<Task>(
      data: task,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 280,
          child: _buildCardContent(context, isDragging: true),
        ),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
          color: Colors.grey[100],
        ),
        child: _buildCardContent(context, isPlaceholder: true),
      ),
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context, {bool isDragging = false, bool isPlaceholder = false}) {
    final formatter = TaskFormattingUseCase();
    final opacity = isPlaceholder ? 0.3 : 1.0;

    return Card(
      elevation: isDragging ? 8 : 2,
      margin: EdgeInsets.zero,
      child: Opacity(
        opacity: opacity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー部分（優先度とアクション）
              Row(
                children: [
                  _buildPriorityIndicator(formatter),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!isDragging && !isPlaceholder) _buildActionMenu(),
                ],
              ),

              // 説明文
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 8),

              // フッター部分（時間と期日）
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    formatter.formatEstimatedTime(task.estimatedMinutes),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (task.dueDate != null) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.event,
                      size: 14,
                      color: formatter.getDueDateColor(task),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatter.formatDueDate(task.dueDate!),
                      style: TextStyle(
                        fontSize: 11,
                        color: formatter.getDueDateColor(task),
                        fontWeight: task.isOverdue ? FontWeight.bold : null,
                      ),
                    ),
                  ],
                ],
              ),

              // ステータスボタン（ドラッグ中は非表示）
              if (!isDragging && !isPlaceholder && onStatusToggle != null) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onStatusToggle,
                    icon: Icon(
                      _getStatusIcon(),
                      size: 16,
                    ),
                    label: Text(
                      _getStatusButtonText(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(TaskFormattingUseCase formatter) {
    final indicatorData = formatter.getPriorityIndicatorData(task.priority);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: indicatorData.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        indicatorData.icon,
        color: indicatorData.color,
        size: 14,
      ),
    );
  }

  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
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
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text('編集'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 16),
              SizedBox(width: 8),
              Text('削除'),
            ],
          ),
        ),
      ],
      child: Icon(
        Icons.more_vert,
        size: 16,
        color: Colors.grey[600],
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (task.status) {
      case TaskStatus.upcoming:
        return Icons.play_arrow;
      case TaskStatus.inProgress:
        return Icons.check_circle;
      case TaskStatus.completed:
        return Icons.refresh;
    }
  }

  String _getStatusButtonText() {
    switch (task.status) {
      case TaskStatus.upcoming:
        return '開始';
      case TaskStatus.inProgress:
        return '完了';
      case TaskStatus.completed:
        return '再開';
    }
  }
}