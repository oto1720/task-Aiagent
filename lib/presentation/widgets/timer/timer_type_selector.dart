// lib/presentation/widgets/timer/timer_type_selector.dart

import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/timer.dart' as timer_entity;

/// タイマータイプ選択ウィジェット
class TimerTypeSelector extends StatelessWidget {
  final Function(timer_entity.TimerType) onTypeSelected;
  final timer_entity.TimerType? selectedType;

  const TimerTypeSelector({
    super.key,
    required this.onTypeSelected,
    this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTypeButton(
          context,
          type: timer_entity.TimerType.pomodoro,
          label: 'ポモドーロ',
          subtitle: '25分',
          icon: Icons.work_outline,
          color: Theme.of(context).primaryColor,
        ),
        _buildTypeButton(
          context,
          type: timer_entity.TimerType.shortBreak,
          label: '短い休憩',
          subtitle: '5分',
          icon: Icons.coffee_outlined,
          color: Colors.green,
        ),
        _buildTypeButton(
          context,
          type: timer_entity.TimerType.longBreak,
          label: '長い休憩',
          subtitle: '15分',
          icon: Icons.free_breakfast_outlined,
          color: Colors.blue,
        ),
        _buildTypeButton(
          context,
          type: timer_entity.TimerType.custom,
          label: 'カスタム',
          subtitle: '設定',
          icon: Icons.settings_outlined,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildTypeButton(
    BuildContext context, {
    required timer_entity.TimerType type,
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedType == type;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () => onTypeSelected(type),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? color : Colors.grey[600],
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? color : Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
