import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/usecases/task/task_formatting_usecase.dart';
import 'package:task_aiagent/presentation/widgets/task/task_card.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final TaskStatus tabStatus;
  final Function(int oldIndex, int newIndex)? onReorder;
  final Function(Task task)? onStatusToggle;
  final Function(Task task)? onComplete;
  final Function(Task task)? onEdit;
  final Function(Task task)? onDelete;

  const TaskList({
    super.key,
    required this.tasks,
    required this.tabStatus,
    this.onReorder,
    this.onStatusToggle,
    this.onComplete,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      onReorder: onReorder ?? (oldIndex, newIndex) {},
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          key: ValueKey(task.id),
          task: task,
          onStatusToggle: onStatusToggle != null
              ? () => onStatusToggle!(task)
              : null,
          onComplete: onComplete != null
              ? () => onComplete!(task)
              : null,
          onEdit: onEdit != null
              ? () => onEdit!(task)
              : null,
          onDelete: onDelete != null
              ? () => onDelete!(task)
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final formatter = TaskFormattingUseCase();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            formatter.getEmptyStateIcon(tabStatus),
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            formatter.getEmptyStateMessage(tabStatus),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}