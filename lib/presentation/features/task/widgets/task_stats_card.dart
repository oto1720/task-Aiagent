import 'package:flutter/material.dart';
import 'package:task_aiagent/core/constant/themes.dart';

class TaskStatsCard extends StatelessWidget {
  final Map<String, int> stats;

  const TaskStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, AppThemes.paleOrange],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              label: '全タスク',
              count: stats['total'] ?? 0,
              icon: Icons.format_list_bulleted_rounded,
              color: AppThemes.textColor,
            ),
            _buildDivider(),
            _buildStatItem(
              label: 'アクティブ',
              count: stats['active'] ?? 0,
              icon: Icons.trending_up_rounded,
              color: AppThemes.primaryOrange,
            ),
            _buildDivider(),
            _buildStatItem(
              label: '完了',
              count: stats['completed'] ?? 0,
              icon: Icons.check_circle_rounded,
              color: AppThemes.successColor,
            ),
            _buildDivider(),
            _buildStatItem(
              label: '緊急',
              count: stats['urgent'] ?? 0,
              icon: Icons.priority_high_rounded,
              color: AppThemes.errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 50, color: AppThemes.grey200);
  }

  Widget _buildStatItem({
    required String label,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 26, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppThemes.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
