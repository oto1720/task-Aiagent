import 'package:flutter/material.dart';

/// カレンダーアクションバーウィジェット
class CalendarActionBar extends StatelessWidget {
  final VoidCallback onAddSchedule;

  const CalendarActionBar({super.key, required this.onAddSchedule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: onAddSchedule,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('スケジュール追加'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
