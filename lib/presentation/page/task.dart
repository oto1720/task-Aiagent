import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/presentation/providers/task_provider.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/usecases/task/task_management_usecase.dart';
import 'package:task_aiagent/presentation/widgets/task/task_list.dart';
import 'package:task_aiagent/presentation/widgets/task/task_stats_card.dart';
import 'package:task_aiagent/presentation/widgets/task/task_form_dialog.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final _taskManagement = TaskManagementUseCase();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);
    final taskStats = ref.watch(taskStatsProvider);

    final filteredTasks = _taskManagement.filterTasks(tasks, _searchQuery);
    final upcomingTasks = _taskManagement.getUpcomingTasks(filteredTasks);
    final todayTasks = _taskManagement.getTodayTasks(filteredTasks);
    final completedTasks = _taskManagement.getCompletedTasks(filteredTasks);

    return Scaffold(
      appBar: _buildAppBar(upcomingTasks, todayTasks, completedTasks),
      body: Column(
        children: [
          TaskStatsCard(stats: taskStats),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TaskList(
                  tasks: upcomingTasks,
                  tabStatus: TaskStatus.upcoming,
                  onReorder: _handleReorder,
                  onStatusToggle: _handleStatusToggle,
                  onComplete: _handleComplete,
                  onEdit: _handleEdit,
                  onDelete: _handleDelete,
                ),
                TaskList(
                  tasks: todayTasks,
                  tabStatus: TaskStatus.inProgress,
                  onReorder: _handleReorder,
                  onStatusToggle: _handleStatusToggle,
                  onComplete: _handleComplete,
                  onEdit: _handleEdit,
                  onDelete: _handleDelete,
                ),
                TaskList(
                  tasks: completedTasks,
                  tabStatus: TaskStatus.completed,
                  onComplete: _handleComplete,
                  onEdit: _handleEdit,
                  onDelete: _handleDelete,
                ),
              ],
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

  PreferredSizeWidget _buildAppBar(
    List<Task> upcomingTasks,
    List<Task> todayTasks,
    List<Task> completedTasks,
  ) {
    return AppBar(
      title: const Text('タスク管理'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            _buildSearchBar(),
            _buildTabBar(upcomingTasks, todayTasks, completedTasks),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
          border: const OutlineInputBorder(),
        ),
        onChanged: _updateSearchQuery,
      ),
    );
  }

  Widget _buildTabBar(
    List<Task> upcomingTasks,
    List<Task> todayTasks,
    List<Task> completedTasks,
  ) {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(
          text: 'これから (${upcomingTasks.length})',
          icon: const Icon(Icons.schedule),
        ),
        Tab(
          text: '今日のタスク (${todayTasks.length})',
          icon: const Icon(Icons.today),
        ),
        Tab(
          text: '完了 (${completedTasks.length})',
          icon: const Icon(Icons.check_circle),
        ),
      ],
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

  void _handleReorder(int oldIndex, int newIndex) {
    final tasks = ref.read(taskListProvider);
    final currentTab = _tabController.index;

    List<Task> relevantTasks;
    switch (currentTab) {
      case 0:
        relevantTasks = _taskManagement.getUpcomingTasks(tasks);
        break;
      case 1:
        relevantTasks = _taskManagement.getTodayTasks(tasks);
        break;
      default:
        return; // 完了タスクは並び替え不可
    }

    final reorderedTasks = _taskManagement.updateTaskOrder(
      relevantTasks,
      oldIndex,
      newIndex,
    );

    // 並び替えられたタスクを保存
    for (final task in reorderedTasks) {
      ref.read(taskListProvider.notifier).updateTask(task);
    }
  }

  void _handleStatusToggle(Task task) {
    final newStatus = task.status == TaskStatus.inProgress
        ? TaskStatus.upcoming
        : TaskStatus.inProgress;

    final updatedTask = _taskManagement.toggleTaskStatus(task, newStatus);
    ref.read(taskListProvider.notifier).updateTask(updatedTask);
  }

  void _handleComplete(Task task) {
    final updatedTask = _taskManagement.toggleCompletion(task);
    ref.read(taskListProvider.notifier).updateTask(updatedTask);
  }

  void _handleEdit(Task task) {
    _showEditTaskDialog(task);
  }

  void _handleDelete(Task task) {
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