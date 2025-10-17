// lib/presentation/widgets/timer/timer_type_selector.dart

import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/timer.dart' as timer_entity;
import 'package:task_aiagent/core/constant/themes.dart';

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
          icon: Icons.work_outline_rounded,
          color: AppThemes.primaryBlue,
        ),
        _buildTypeButton(
          context,
          type: timer_entity.TimerType.shortBreak,
          label: '短い休憩',
          subtitle: '5分',
          icon: Icons.coffee_outlined,
          color: AppThemes.successColor,
        ),
        _buildTypeButton(
          context,
          type: timer_entity.TimerType.longBreak,
          label: '長い休憩',
          subtitle: '15分',
          icon: Icons.free_breakfast_outlined,
          color: AppThemes.darkBlue,
        ),
        _buildTypeButton(
          context,
          type: timer_entity.TimerType.custom,
          label: 'カスタム',
          subtitle: '設定',
          icon: Icons.settings_outlined,
          color: AppThemes.lightBlue,
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
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : AppThemes.grey50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : AppThemes.grey300,
                width: isSelected ? 2.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.15)
                        : AppThemes.grey200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? color : AppThemes.grey600,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? color : AppThemes.textColor,
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
                    color: isSelected
                        ? color.withValues(alpha: 0.8)
                        : AppThemes.secondaryTextColor,
                    fontWeight: FontWeight.w500,
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
