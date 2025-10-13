import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/core/constant/themes.dart';

/// 日付ヘッダーウィジェット
class DateHeader extends StatelessWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy年MM月dd日 (E)', 'ja_JP');

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, AppThemes.paleOrange],
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
}
