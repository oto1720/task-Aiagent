import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/usecases/task/task_management_usecase.dart';
import 'package:task_aiagent/presentation/providers/task_providers.dart';
import 'package:task_aiagent/presentation/features/task/widgets/task_search_bar.dart';
import 'package:task_aiagent/presentation/features/task/widgets/task_stats_card.dart';
import 'package:task_aiagent/presentation/features/task/widgets/task_board.dart';
import 'package:task_aiagent/presentation/features/task/widgets/task_form_dialog.dart';

/// タスクフィーチャーメインウィジェット
class TaskFeature extends ConsumerStatefulWidget {
  const TaskFeature({super.key});

  @override
  ConsumerState<TaskFeature> createState() => _TaskFeatureState();
}

class _TaskFeatureState extends ConsumerState<TaskFeature> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final _taskManagement = TaskManagementUseCase();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskListProvider);
    final taskStats = ref.watch(taskStatsProvider);

    return tasksAsync.when(
      data: (tasks) {
        final filteredTasks = _taskManagement.filterTasks(tasks, _searchQuery);
        final upcomingTasks = _taskManagement.getUpcomingTasks(filteredTasks);
        final inProgressTasks = _taskManagement.getInProgressTasks(
          filteredTasks,
        );
        final completedTasks = _taskManagement.getCompletedTasks(filteredTasks);

        return Column(
          children: [
            // 統計カード
            TaskStatsCard(stats: taskStats),

            // 検索バー
            TaskSearchBar(
              controller: _searchController,
              searchQuery: _searchQuery,
              onChanged: _updateSearchQuery,
              onClear: _clearSearch,
            ),

            // Kanbanボード
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TaskBoard(
                  upcomingTasks: upcomingTasks,
                  inProgressTasks: inProgressTasks,
                  completedTasks: completedTasks,
                  onTaskStatusChanged: _handleTaskStatusChanged,
                  onTaskEdit: _handleTaskEdit,
                  onTaskDelete: _handleTaskDelete,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('エラー: $error')),
    );
  }

  void _updateSearchQuery(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _handleTaskStatusChanged(Task task, TaskStatus newStatus) {
    final updatedTask = task.copyWith(status: newStatus);
    ref.read(taskListProvider.notifier).updateTask(updatedTask);
  }

  void _handleTaskEdit(Task task) {
    _showEditTaskDialog(task);
  }

  void _handleTaskDelete(Task task) {
    _showDeleteConfirmDialog(task);
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        task: task,
        onSave: (updatedTask) {
          ref.read(taskListProvider.notifier).updateTask(updatedTask);
        },
      ),
    );
  }

  void _showDeleteConfirmDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを削除'),
        content: Text('「${task.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskListProvider.notifier).deleteTask(task.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}
