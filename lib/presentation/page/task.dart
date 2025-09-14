// lib/presentation/page/task.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/presentation/providers/task_provider.dart';
import 'package:task_aiagent/domain/entities/task.dart';

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

    final filteredTasks = _filterTasks(tasks);
    final pendingTasks = filteredTasks.where((t) => t.status != TaskStatus.completed).toList();
    final inProgressTasks = filteredTasks.where((t) => t.status == TaskStatus.inProgress).toList();
    final completedTasks = filteredTasks.where((t) => t.status == TaskStatus.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('タスク管理'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: '未完了',
              icon: Badge(
                label: Text('${taskStats['pending']}'),
                child: const Icon(Icons.pending_actions),
              ),
            ),
            Tab(
              text: '進行中',
              icon: Badge(
                label: Text('${taskStats['inProgress']}'),
                child: const Icon(Icons.play_arrow),
              ),
            ),
            Tab(
              text: '完了済み',
              icon: Badge(
                label: Text('${taskStats['completed']}'),
                child: const Icon(Icons.check_circle),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 検索バー
          _buildSearchBar(),
          
          // タブビュー
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(pendingTasks, TaskStatus.pending),
                _buildTaskList(inProgressTasks, TaskStatus.inProgress),
                _buildTaskList(completedTasks, TaskStatus.completed),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'タスクを検索...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, TaskStatus status) {
    if (tasks.isEmpty) {
      return _buildEmptyState(status);
    }

    // 優先度でソート
    tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildEmptyState(TaskStatus status) {
    String message;
    IconData icon;
    
    switch (status) {
      case TaskStatus.pending:
        message = 'すべてのタスクが完了しています！\n新しいタスクを追加してみましょう。';
        icon = Icons.task_alt;
        break;
      case TaskStatus.inProgress:
        message = '現在進行中のタスクはありません。\nタスクを開始してみましょう。';
        icon = Icons.play_arrow;
        break;
      case TaskStatus.completed:
        message = 'まだ完了したタスクがありません。\nタスクを完了させてみましょう。';
        icon = Icons.check_circle_outline;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    final priorityColor = _getPriorityColor(task.priority);
    final isCompleted = task.status == TaskStatus.completed;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showTaskDetailDialog(task),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border(left: BorderSide(color: priorityColor, width: 4)),
            color: priorityColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // チェックボックス
                    Checkbox(
                      value: isCompleted,
                      onChanged: (_) => _toggleTaskStatus(task),
                    ),
                    
                    // タスク情報
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCompleted ? Colors.grey : null,
                            ),
                          ),
                          if (task.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              task.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // カテゴリ
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  task.category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              
                              // 推定時間
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${task.estimatedMinutes}分',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Spacer(),
                              
                              // 作成日
                              Text(
                                DateFormat('MM/dd').format(task.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // 優先度インジケーター
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: priorityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getPriorityText(task.priority),
                          style: TextStyle(
                            fontSize: 10,
                            color: priorityColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    // メニューボタン
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: const Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('編集'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'status',
                          child: Row(
                            children: [
                              Icon(
                                task.status == TaskStatus.inProgress
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                task.status == TaskStatus.inProgress
                                    ? '一時停止'
                                    : '開始',
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: const Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('削除', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) => _handleMenuAction(value, task),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Task> _filterTasks(List<Task> tasks) {
    if (_searchQuery.isEmpty) return tasks;
    
    return tasks.where((task) {
      return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return '高';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.low:
        return '低';
    }
  }

  void _toggleTaskStatus(Task task) {
    final newStatus = task.status == TaskStatus.completed
        ? TaskStatus.pending
        : TaskStatus.completed;
    
    final updatedTask = task.copyWith(status: newStatus);
    ref.read(taskListProvider.notifier).updateTask(updatedTask);
  }

  void _handleMenuAction(String action, Task task) {
    switch (action) {
      case 'edit':
        _showEditTaskDialog(task);
        break;
      case 'status':
        final newStatus = task.status == TaskStatus.inProgress
            ? TaskStatus.pending
            : TaskStatus.inProgress;
        final updatedTask = task.copyWith(status: newStatus);
        ref.read(taskListProvider.notifier).updateTask(updatedTask);
        break;
      case 'delete':
        _showDeleteConfirmDialog(task);
        break;
    }
  }

  void _showTaskDetailDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) ...[
              const Text('説明:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(task.description),
              const SizedBox(height: 16),
            ],
            const Text('カテゴリ:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(task.category),
            const SizedBox(height: 8),
            const Text('優先度:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_getPriorityText(task.priority)),
            const SizedBox(height: 8),
            const Text('推定時間:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${task.estimatedMinutes}分'),
            const SizedBox(height: 8),
            const Text('作成日:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(DateFormat('yyyy年MM月dd日 HH:mm').format(task.createdAt)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditTaskDialog(task);
            },
            child: const Text('編集'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    _showTaskFormDialog(null);
  }

  void _showEditTaskDialog(Task task) {
    _showTaskFormDialog(task);
  }

  void _showTaskFormDialog(Task? task) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');
    final categoryController = TextEditingController(text: task?.category ?? 'General');
    TaskPriority selectedPriority = task?.priority ?? TaskPriority.medium;
    int estimatedMinutes = task?.estimatedMinutes ?? 30;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task == null ? '新しいタスクを追加' : 'タスクを編集'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'タスク名*',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: '説明',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'カテゴリ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskPriority>(
                  value: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: '優先度',
                    border: OutlineInputBorder(),
                  ),
                  items: TaskPriority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getPriorityColor(priority),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(_getPriorityText(priority)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('推定時間: '),
                    Expanded(
                      child: Slider(
                        value: estimatedMinutes.toDouble(),
                        min: 15,
                        max: 180,
                        divisions: 11,
                        label: '$estimatedMinutes分',
                        onChanged: (value) {
                          setState(() {
                            estimatedMinutes = value.round();
                          });
                        },
                      ),
                    ),
                    Text('$estimatedMinutes分'),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                if (task == null) {
                  // 新規追加
                  final newTask = Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    category: categoryController.text,
                    priority: selectedPriority,
                    estimatedMinutes: estimatedMinutes,
                  );
                  ref.read(taskListProvider.notifier).addTask(newTask);
                } else {
                  // 編集
                  final updatedTask = task.copyWith(
                    title: titleController.text,
                    description: descriptionController.text,
                    category: categoryController.text,
                    priority: selectedPriority,
                    estimatedMinutes: estimatedMinutes,
                  );
                  ref.read(taskListProvider.notifier).updateTask(updatedTask);
                }
                Navigator.of(context).pop();
              }
            },
            child: Text(task == null ? '追加' : '更新'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを削除'),
        content: Text('「${task.title}」を削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(taskListProvider.notifier).deleteTask(task.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('「${task.title}」を削除しました'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}