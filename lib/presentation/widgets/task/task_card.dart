import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/usecases/task/task_formatting_usecase.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: _buildPriorityIndicator(formatter),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.status == TaskStatus.completed
                ? TextDecoration.lineThrough
                : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: _buildSubtitle(formatter),
        trailing: _buildActions(),
      ),
    );
  }

  Widget _buildPriorityIndicator(TaskFormattingUseCase formatter) {
    final indicatorData = formatter.getPriorityIndicatorData(task.priority);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: indicatorData.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        indicatorData.icon,
        color: indicatorData.color,
        size: 20,
      ),
    );
  }

  Widget _buildSubtitle(TaskFormattingUseCase formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (task.description.isNotEmpty)
          Text(
            task.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              formatter.formatEstimatedTime(task.estimatedMinutes),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            if (task.dueDate != null) ...[
              const SizedBox(width: 16),
              Icon(
                Icons.event,
                size: 16,
                color: formatter.getDueDateColor(task),
              ),
              const SizedBox(width: 4),
              Text(
                formatter.formatDueDate(task.dueDate!),
                style: TextStyle(
                  color: formatter.getDueDateColor(task),
                  fontSize: 12,
                  fontWeight: task.isOverdue ? FontWeight.bold : null,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (task.status != TaskStatus.completed && onStatusToggle != null)
          IconButton(
            icon: Icon(
              task.status == TaskStatus.inProgress
                  ? Icons.pause_circle
                  : Icons.play_circle,
              color: task.status == TaskStatus.inProgress
                  ? Colors.orange
                  : Colors.green,
            ),
            onPressed: onStatusToggle,
          ),
        if (onComplete != null)
          IconButton(
            icon: Icon(
              task.status == TaskStatus.completed
                  ? Icons.refresh
                  : Icons.check_circle,
              color: task.status == TaskStatus.completed
                  ? Colors.grey
                  : Colors.green,
            ),
            onPressed: onComplete,
          ),
        PopupMenuButton<String>(
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
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('編集'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('削除'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}