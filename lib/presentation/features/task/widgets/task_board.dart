import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/presentation/widgets/task/task_column.dart';

class TaskBoard extends StatelessWidget {
  final List<Task> upcomingTasks;
  final List<Task> inProgressTasks;
  final List<Task> completedTasks;
  final Function(Task task, TaskStatus newStatus) onTaskStatusChanged;
  final Function(Task task) onTaskEdit;
  final Function(Task task) onTaskDelete;

  const TaskBoard({
    super.key,
    required this.upcomingTasks,
    required this.inProgressTasks,
    required this.completedTasks,
    required this.onTaskStatusChanged,
    required this.onTaskEdit,
    required this.onTaskDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // これからのタスク
        Expanded(
          child: TaskColumn(
            title: 'これから',
            status: TaskStatus.upcoming,
            tasks: upcomingTasks,
            color: Colors.blue,
            icon: Icons.schedule,
            onTaskStatusChanged: onTaskStatusChanged,
            onTaskEdit: onTaskEdit,
            onTaskDelete: onTaskDelete,
          ),
        ),
        const SizedBox(width: 8),

        // 今日進行中のタスク
        Expanded(
          child: TaskColumn(
            title: '今日進行中',
            status: TaskStatus.inProgress,
            tasks: inProgressTasks,
            color: Colors.orange,
            icon: Icons.play_arrow,
            onTaskStatusChanged: onTaskStatusChanged,
            onTaskEdit: onTaskEdit,
            onTaskDelete: onTaskDelete,
          ),
        ),
        const SizedBox(width: 8),

        // 完了済みタスク
        Expanded(
          child: TaskColumn(
            title: '完了',
            status: TaskStatus.completed,
            tasks: completedTasks,
            color: Colors.green,
            icon: Icons.check_circle,
            onTaskStatusChanged: onTaskStatusChanged,
            onTaskEdit: onTaskEdit,
            onTaskDelete: onTaskDelete,
          ),
        ),
      ],
    );
  }
}
