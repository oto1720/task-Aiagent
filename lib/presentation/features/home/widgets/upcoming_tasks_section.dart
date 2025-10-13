import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/core/constant/themes.dart';
import 'package:task_aiagent/presentation/providers/task_providers.dart';
import 'package:task_aiagent/presentation/shared/components/priority_indicator.dart';
import 'package:task_aiagent/presentation/shared/components/time_info_chip.dart';

/// 近日中のタスクセクションウィジェット
class UpcomingTasksSection extends ConsumerWidget {
  final List<Task> tasks;

  const UpcomingTasksSection({super.key, required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayTasks = tasks.take(5).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppThemes.primaryOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.upcoming_rounded,
                        color: AppThemes.primaryOrange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '近日中のタスク',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.textColor,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.go('/tasks'),
                  child: const Text('すべて見る'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (displayTasks.isEmpty)
              _buildEmptyState()
            else
              Column(
                children: displayTasks.map((task) {
                  return _buildTaskTile(context, ref, task);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppThemes.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppThemes.grey200, width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: AppThemes.successColor.withValues(alpha: 0.5),
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'すべてのタスクが完了しています！',
            style: TextStyle(color: AppThemes.secondaryTextColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, WidgetRef ref, Task task) {
    final priorityColor = PriorityIndicator.getPriorityColor(task.priority);

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
            Container(
              width: 4,
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
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: ListTile(
                  leading: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: task.status == TaskStatus.completed,
                      onChanged: (_) => ref
                          .read(taskListProvider.notifier)
                          .completeTask(task.id),
                      activeColor: AppThemes.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.status == TaskStatus.completed
                          ? TextDecoration.lineThrough
                          : null,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: task.status == TaskStatus.completed
                          ? AppThemes.grey400
                          : AppThemes.textColor,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        TimeInfoChip(timeText: '${task.estimatedMinutes}分'),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.folder_outlined,
                          size: 14,
                          color: AppThemes.secondaryTextColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            task.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppThemes.secondaryTextColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: priorityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
