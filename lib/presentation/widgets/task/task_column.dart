import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/presentation/widgets/task/draggable_task_card.dart';

class TaskColumn extends StatelessWidget {
  final String title;
  final TaskStatus status;
  final List<Task> tasks;
  final Color color;
  final IconData icon;
  final Function(Task task, TaskStatus newStatus) onTaskStatusChanged;
  final Function(Task task) onTaskEdit;
  final Function(Task task) onTaskDelete;

  const TaskColumn({
    super.key,
    required this.title,
    required this.status,
    required this.tasks,
    required this.color,
    required this.icon,
    required this.onTaskStatusChanged,
    required this.onTaskEdit,
    required this.onTaskDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // カラムヘッダー
        _buildColumnHeader(context),
        const SizedBox(height: 8),

        // タスクリスト
        Expanded(
          child: DragTarget<Task>(
            onWillAcceptWithDetails: (details) {
              final task = details.data;
              print('onWillAcceptWithDetails: task=${task.title}, currentStatus=${task.status}, targetStatus=$status');
              return task.status != status;
            },
            onAcceptWithDetails: (details) {
              final task = details.data;
              print('onAcceptWithDetails: task=${task.title}, from=${task.status}, to=$status');
              onTaskStatusChanged(task, status);
            },
            builder: (context, candidateItems, rejectedItems) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: candidateItems.isNotEmpty
                      ? color.withValues(alpha: 0.1)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: candidateItems.isNotEmpty
                        ? color.withValues(alpha: 0.5)
                        : Colors.grey[300]!,
                    width: candidateItems.isNotEmpty ? 2 : 1,
                  ),
                ),
                child: tasks.isEmpty
                    ? _buildEmptyState()
                    : _buildTaskList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            '$title (${tasks.length})',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptyMessage(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    // 優先度順にソート（高い優先度が上に表示）
    final sortedTasks = List<Task>.from(tasks)
      ..sort((a, b) => a.priorityOrder.compareTo(b.priorityOrder));

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sortedTasks.length,
      itemBuilder: (context, index) {
        final task = sortedTasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: DraggableTaskCard(
            task: task,
            onEdit: () => onTaskEdit(task),
            onDelete: () => onTaskDelete(task),
            onStatusToggle: () {
              TaskStatus newStatus;
              switch (task.status) {
                case TaskStatus.upcoming:
                  newStatus = TaskStatus.inProgress;
                  break;
                case TaskStatus.inProgress:
                  newStatus = TaskStatus.completed;
                  break;
                case TaskStatus.completed:
                  newStatus = TaskStatus.upcoming;
                  break;
              }
              onTaskStatusChanged(task, newStatus);
            },
          ),
        );
      },
    );
  }

  String _getEmptyMessage() {
    switch (status) {
      case TaskStatus.upcoming:
        return 'これからのタスクが\nここに表示されます';
      case TaskStatus.inProgress:
        return '進行中のタスクが\nここに表示されます';
      case TaskStatus.completed:
        return '完了したタスクが\nここに表示されます';
    }
  }
}