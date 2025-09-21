import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/domain/entities/task.dart';

class TaskFormattingUseCase {
  // 期日の色を取得
  Color getDueDateColor(Task task) {
    if (task.isOverdue) return Colors.red;
    if (task.isDueToday) return Colors.orange;
    if (task.isDueTomorrow) return Colors.blue;
    return Colors.grey[600]!;
  }

  // 期日のテキストを取得
  String formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (dueDay == today) return '今日';
    if (dueDay == tomorrow) return '明日';
    if (dueDay.isBefore(today)) return '期限切れ';

    return DateFormat('M/d').format(dueDate);
  }

  // 優先度のラベルを取得
  String getPriorityLabel(TaskPriority priority) {
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

  // 優先度のアイコンと色を取得
  PriorityIndicatorData getPriorityIndicatorData(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return PriorityIndicatorData(
          color: Colors.deepPurple,
          icon: Icons.priority_high,
        );
      case TaskPriority.high:
        return PriorityIndicatorData(
          color: Colors.red,
          icon: Icons.keyboard_arrow_up,
        );
      case TaskPriority.medium:
        return PriorityIndicatorData(
          color: Colors.orange,
          icon: Icons.remove,
        );
      case TaskPriority.low:
        return PriorityIndicatorData(
          color: Colors.green,
          icon: Icons.keyboard_arrow_down,
        );
    }
  }

  // ステータス別の空状態アイコンを取得
  IconData getEmptyStateIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.upcoming:
        return Icons.schedule;
      case TaskStatus.inProgress:
        return Icons.today;
      case TaskStatus.completed:
        return Icons.check_circle_outline;
    }
  }

  // ステータス別の空状態メッセージを取得
  String getEmptyStateMessage(TaskStatus status) {
    switch (status) {
      case TaskStatus.upcoming:
        return 'これからのタスクはありません';
      case TaskStatus.inProgress:
        return '今日のタスクはありません';
      case TaskStatus.completed:
        return '完了したタスクはありません';
    }
  }

  // 所要時間のフォーマット
  String formatEstimatedTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}分';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '${hours}時間';
      } else {
        return '${hours}時間${remainingMinutes}分';
      }
    }
  }

  // タスクの進捗率を計算（将来的な機能用）
  double calculateProgress(Task task) {
    // 現在はステータスベースだが、将来的にはより詳細な進捗管理も可能
    switch (task.status) {
      case TaskStatus.upcoming:
        return 0.0;
      case TaskStatus.inProgress:
        return 0.5;
      case TaskStatus.completed:
        return 1.0;
    }
  }
}

class PriorityIndicatorData {
  final Color color;
  final IconData icon;

  const PriorityIndicatorData({
    required this.color,
    required this.icon,
  });
}