// lib/presentation/page/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/presentation/providers/task_providers.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:go_router/go_router.dart';
import 'package:task_aiagent/presentation/providers/schedule_providers.dart';
import 'package:task_aiagent/core/constant/themes.dart';

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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppThemes.paleOrange,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppThemes.primaryOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.today_rounded,
                size: 32,
                color: AppThemes.primaryOrange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(now),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppThemes.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getGreetingMessage(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppThemes.secondaryTextColor,
                    ),
                  ),
                ],
              ),
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
            Icons.assignment_rounded,
            AppThemes.textColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            '未完了',
            stats['pending']?.toString() ?? '0',
            Icons.pending_actions_rounded,
            AppThemes.primaryOrange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            '完了済み',
            stats['completed']?.toString() ?? '0',
            Icons.check_circle_rounded,
            AppThemes.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppThemes.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleGenerationCard(BuildContext context, WidgetRef ref, bool hasTask) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppThemes.darkOrange.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppThemes.paleOrange.withValues(alpha: 0.3),
              AppThemes.paleOrange,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppThemes.darkOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppThemes.darkOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AI時間割生成',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppThemes.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              hasTask
                  ? 'AIがあなたのタスクを分析して、最適な時間割を自動生成します。'
                  : 'タスクを追加してからAI時間割を生成してください。',
              style: const TextStyle(
                color: AppThemes.secondaryTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: hasTask
                    ? () => _generateSchedule(context, ref)
                    : null,
                icon: const Icon(Icons.schedule_rounded),
                label: const Text('今日の時間割を生成'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySchedule(BuildContext context, DailySchedule? schedule) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    Icons.schedule_rounded,
                    color: AppThemes.primaryOrange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '今日のスケジュール',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppThemes.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (schedule == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppThemes.grey50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppThemes.grey200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: AppThemes.grey400,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'まだスケジュールが生成されていません',
                      style: TextStyle(
                        color: AppThemes.secondaryTextColor,
                        fontSize: 14,
                      ),
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
      case TaskPriority.urgent:
        priorityColor = AppThemes.errorColor;
        break;
      case TaskPriority.high:
        priorityColor = AppThemes.primaryOrange;
        break;
      case TaskPriority.medium:
        priorityColor = AppThemes.lightOrange;
        break;
      case TaskPriority.low:
        priorityColor = AppThemes.successColor;
        break;
    }

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
              width: 5,
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
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            startTime,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: priorityColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Icon(
                            Icons.arrow_downward_rounded,
                            size: 12,
                            color: priorityColor,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            endTime,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: priorityColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            block.taskTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppThemes.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_outlined,
                                size: 14,
                                color: AppThemes.secondaryTextColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${block.durationInMinutes}分',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppThemes.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: priorityColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getPriorityText(block.priority),
                        style: TextStyle(
                          fontSize: 11,
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppThemes.grey50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppThemes.grey200,
                    width: 1,
                  ),
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
                      style: TextStyle(
                        color: AppThemes.secondaryTextColor,
                        fontSize: 14,
                      ),
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
    final priorityColor = _getPriorityColor(task.priority);

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
                      onChanged: (_) => ref.read(taskListProvider.notifier).completeTask(task.id),
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
                        Icon(
                          Icons.schedule_outlined,
                          size: 14,
                          color: AppThemes.secondaryTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${task.estimatedMinutes}分',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppThemes.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
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

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return AppThemes.errorColor;
      case TaskPriority.high:
        return AppThemes.primaryOrange;
      case TaskPriority.medium:
        return AppThemes.lightOrange;
      case TaskPriority.low:
        return AppThemes.successColor;
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