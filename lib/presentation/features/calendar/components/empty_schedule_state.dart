import 'package:flutter/material.dart';


/// 空のスケジュール状態コンポーネント
class EmptyScheduleState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyScheduleState({
    super.key,
    this.message = 'まだスケジュールがありません',
    this.icon = Icons.calendar_today,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[400], size: 48),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
