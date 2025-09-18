import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/presentation/providers/task_provider.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/usecases/task/task_management_usecase.dart';
import 'package:task_aiagent/presentation/widgets/task/task_board.dart';
import 'package:task_aiagent/presentation/widgets/task/task_stats_card.dart';
import 'package:task_aiagent/presentation/widgets/task/task_form_dialog.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
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
    final tasks = ref.watch(taskListProvider);
    final taskStats = ref.watch(taskStatsProvider);

    final filteredTasks = _taskManagement.filterTasks(tasks, _searchQuery);
    final upcomingTasks = _taskManagement.getUpcomingTasks(filteredTasks);
    final inProgressTasks = _taskManagement.getInProgressTasks(filteredTasks);
    final completedTasks = _taskManagement.getCompletedTasks(filteredTasks);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 統計カード
          TaskStatsCard(stats: taskStats),

          // 検索バー
          _buildSearchBar(),

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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('タスク追加'),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('タスク管理ボード'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'タスクを検索...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        onChanged: _updateSearchQuery,
      ),
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
    print('_handleTaskStatusChanged: task=${task.title}, oldStatus=${task.status}, newStatus=$newStatus');

    // toggleTaskStatusではなく、直接copyWithを使用
    final updatedTask = task.copyWith(status: newStatus);
    print('updatedTask: title=${updatedTask.title}, status=${updatedTask.status}');

    ref.read(taskListProvider.notifier).updateTask(updatedTask);
  }

  void _handleTaskEdit(Task task) {
    _showEditTaskDialog(task);
  }

  void _handleTaskDelete(Task task) {
    _showDeleteConfirmDialog(task);
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        onSave: (task) {
          ref.read(taskListProvider.notifier).addTask(task);
        },
      ),
    );
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