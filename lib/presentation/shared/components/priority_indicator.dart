import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/core/constant/themes.dart';

/// 優先度インジケーターコンポーネント
class PriorityIndicator extends StatelessWidget {
  final TaskPriority priority;
  final double size;
  final bool showLabel;

  const PriorityIndicator({
    super.key,
    required this.priority,
    this.size = 12,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = getPriorityColor(priority);

    if (showLabel) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Text(
          getPriorityText(priority),
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  /// 優先度に応じた色を取得
  static Color getPriorityColor(TaskPriority priority) {
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

  /// 優先度のテキスト表現を取得
  static String getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return '緊急';
      case TaskPriority.high:
        return '高';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.low:
        return '低';
    }
  }
}
