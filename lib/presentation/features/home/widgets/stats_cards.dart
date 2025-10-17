import 'package:flutter/material.dart';
import 'package:task_aiagent/core/constant/themes.dart';
import 'package:task_aiagent/presentation/features/home/components/stat_card.dart';

/// 統計カード群ウィジェット
class StatsCards extends StatelessWidget {
  final Map<String, int> stats;

  const StatsCards({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: '全タスク',
            value: stats['total']?.toString() ?? '0',
            icon: Icons.assignment_rounded,
            color: AppThemes.textColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatCard(
            title: '未完了',
            value: stats['pending']?.toString() ?? '0',
            icon: Icons.pending_actions_rounded,
            color: AppThemes.primaryBlue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatCard(
            title: '完了済み',
            value: stats['completed']?.toString() ?? '0',
            icon: Icons.check_circle_rounded,
            color: AppThemes.successColor,
          ),
        ),
      ],
    );
  }
}
