// lib/presentation/widgets/timer/pomodoro_stats.dart

import 'package:flutter/material.dart';
import 'package:task_aiagent/core/constant/themes.dart';

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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, AppThemes.paleOrange],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemes.primaryOrange.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemes.primaryOrange.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: Icons.check_circle_outline_rounded,
            label: '今日のポモドーロ',
            value: '$todayCount',
            color: AppThemes.primaryOrange,
          ),
          Container(
            width: 2,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppThemes.grey200,
                  AppThemes.grey300,
                  AppThemes.grey200,
                ],
              ),
            ),
          ),
          _buildStatItem(
            context,
            icon: Icons.refresh_rounded,
            label: '現在のサイクル',
            value: '${currentCycle % 4 + 1}/4',
            color: AppThemes.darkOrange,
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
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppThemes.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
