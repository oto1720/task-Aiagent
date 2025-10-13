import 'package:flutter/material.dart';
import 'package:task_aiagent/core/constant/themes.dart';

/// 時間情報チップコンポーネント
class TimeInfoChip extends StatelessWidget {
  final String timeText;
  final IconData icon;
  final Color? color;

  const TimeInfoChip({
    super.key,
    required this.timeText,
    this.icon = Icons.schedule_outlined,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? AppThemes.secondaryTextColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: displayColor),
        const SizedBox(width: 4),
        Text(timeText, style: TextStyle(fontSize: 12, color: displayColor)),
      ],
    );
  }
}
