// lib/presentation/widgets/timer/pomodoro_stats.dart

import 'package:flutter/material.dart';

/// ポモドーロ統計表示ウィジェット
class PomodoroStats extends StatelessWidget {
  final int todayCount;
  final int currentCycle;

  const PomodoroStats({
    super.key,
    required this.todayCount,
    this.currentCycle = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: Icons.check_circle_outline,
            label: '今日のポモドーロ',
            value: '$todayCount',
            color: Theme.of(context).primaryColor,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          _buildStatItem(
            context,
            icon: Icons.refresh,
            label: '現在のサイクル',
            value: '${currentCycle % 4 + 1}/4',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: 8),
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
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
