// lib/presentation/page/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/presentation/providers/task_providers.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:go_router/go_router.dart';
import 'package:task_aiagent/presentation/providers/schedule_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskStats = ref.watch(taskStatsProvider);
    final todayScheduleAsync = ref.watch(todayScheduleProvider);
    final pendingTasks = ref.watch(activeTasksProvider);

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 今日の日付と挨拶
            _buildDateHeader(),
            const SizedBox(height: 20),

            // タスク統計カード
            _buildStatsCards(taskStats),
            const SizedBox(height: 20),

            // AIスケジュール生成ボタン
            _buildScheduleGenerationCard(context, ref, pendingTasks.isNotEmpty),
            const SizedBox(height: 20),

            // 今日のスケジュール
            todayScheduleAsync.when(
              data: (todaySchedule) => _buildTodaySchedule(context, todaySchedule),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('エラー: $error')),
            ),
            const SizedBox(height: 20),

            // 近日中のタスク
            _buildUpcomingTasks(context, ref, pendingTasks),
          ],
        ),
      );
  }

  Widget _buildDateHeader() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy年MM月dd日 (E)', 'ja_JP');
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.today,
              size: 32,
              color: Colors.blue[600],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(now),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getGreetingMessage(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '今日も一日頑張りましょう！';
    if (hour < 17) return '午後も集中して取り組みましょう！';
    return 'お疲れさまでした！';
  }

  Widget _buildStatsCards(Map<String, int> stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '全タスク',
            stats['total']?.toString() ?? '0',
            Icons.assignment,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            '未完了',
            stats['pending']?.toString() ?? '0',
            Icons.pending_actions,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            '完了済み',
            stats['completed']?.toString() ?? '0',
            Icons.check_circle,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleGenerationCard(BuildContext context, WidgetRef ref, bool hasTask) {
    return Card(
      color: Colors.purple[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.purple[600]),
                const SizedBox(width: 8),
                Text(
                  'AI時間割生成',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hasTask 
                  ? 'AIがあなたのタスクを分析して、最適な時間割を自動生成します。'
                  : 'タスクを追加してからAI時間割を生成してください。',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: hasTask
                    ? () => _generateSchedule(context, ref)
                    : null,
                icon: const Icon(Icons.schedule),
                label: const Text('今日の時間割を生成'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySchedule(BuildContext context, DailySchedule? schedule) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.schedule, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  '今日のスケジュール',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (schedule == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey[400], size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'まだスケジュールが生成されていません',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: schedule.blocks.map((block) {
                  return _buildScheduleBlock(block);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleBlock(ScheduleBlock block) {
    final startTime = DateFormat('HH:mm').format(block.startTime);
    final endTime = DateFormat('HH:mm').format(block.endTime);
    
    Color priorityColor;
    switch (block.priority) {
      case TaskPriority.high:
        priorityColor = Colors.red;
        break;
      case TaskPriority.medium:
        priorityColor = Colors.orange;
        break;
      case TaskPriority.low:
        priorityColor = Colors.green;
        break;
      case TaskPriority.urgent:
        priorityColor = Colors.red;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: priorityColor, width: 4)),
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(
              '$startTime\n$endTime',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  block.taskTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${block.durationInMinutes}分',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getPriorityText(block.priority),
              style: TextStyle(
                fontSize: 10,
                color: priorityColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return '高';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.low:
        return '低';
      case TaskPriority.urgent:
        return '緊急';
    }
  }

  Widget _buildUpcomingTasks(BuildContext context, WidgetRef ref, List<Task> tasks) {
    final displayTasks = tasks.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.upcoming, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      '近日中のタスク',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
            const SizedBox(height: 12),
            if (displayTasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.grey[400], size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'すべてのタスクが完了しています！',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
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

  Widget _buildTaskTile(BuildContext context, WidgetRef ref, Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.status == TaskStatus.completed,
          onChanged: (_) => ref.read(taskListProvider.notifier).completeTask(task.id),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.status == TaskStatus.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Text('${task.estimatedMinutes}分 · ${task.category}'),
        trailing: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getPriorityColor(task.priority),
            shape: BoxShape.circle,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.urgent:
        return Colors.red;
    }
  }

  Future<void> _generateSchedule(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('AI時間割を生成中...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      await ref.read(todayScheduleProvider.notifier).generateTodaySchedule();
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('時間割を生成しました！'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('エラーが発生しました: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

//   Future<void> _showAddTaskDialog(BuildContext context, WidgetRef ref) async {
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();
//     final categoryController = TextEditingController(text: 'General');
//     TaskPriority selectedPriority = TaskPriority.medium;
//     int estimatedMinutes = 30;

//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('新しいタスクを追加'),
//         content: StatefulBuilder(
//           builder: (context, setState) => SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(
//                     labelText: 'タスク名*',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: const InputDecoration(
//                     labelText: '説明',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 2,
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: categoryController,
//                   decoration: const InputDecoration(
//                     labelText: 'カテゴリ',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 DropdownButtonFormField<TaskPriority>(
//                   value: selectedPriority,
//                   decoration: const InputDecoration(
//                     labelText: '優先度',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: TaskPriority.values.map((priority) {
//                     return DropdownMenuItem(
//                       value: priority,
//                       child: Text(_getPriorityText(priority)),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedPriority = value!;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     const Text('推定時間: '),
//                     Expanded(
//                       child: Slider(
//                         value: estimatedMinutes.toDouble(),
//                         min: 15,
//                         max: 180,
//                         divisions: 11,
//                         label: '$estimatedMinutes分',
//                         onChanged: (value) {
//                           setState(() {
//                             estimatedMinutes = value.round();
//                           });
//                         },
//                       ),
//                     ),
//                     Text('$estimatedMinutes分'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('キャンセル'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (titleController.text.isNotEmpty) {
//                 final task = Task(
//                   title: titleController.text,
//                   description: descriptionController.text,
//                   category: categoryController.text,
//                   priority: selectedPriority,
//                   estimatedMinutes: estimatedMinutes,
//                 );
                
//                 ref.read(taskListProvider.notifier).addTask(task);
//                 Navigator.of(context).pop();
//               }
//             },
//             child: const Text('追加'),
//           ),
//         ],
//       ),
//     );
//   }
 }