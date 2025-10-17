// lib/presentation/widgets/timer/timer_display.dart

import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/timer.dart' as timer_entity;
import 'package:task_aiagent/core/constant/themes.dart';

/// タイマー表示ウィジェット
class TimerDisplay extends StatelessWidget {
  final timer_entity.Timer? timer;

  const TimerDisplay({super.key, this.timer});

  @override
  Widget build(BuildContext context) {
    if (timer == null) {
      return _buildIdleState(context);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimerType(context),
        const SizedBox(height: 24),
        _buildCircularTimer(context),
        const SizedBox(height: 24),
        _buildTimeText(context),
      ],
    );
  }

  Widget _buildIdleState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppThemes.paleBlue.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timer_outlined,
              size: 80,
              color: AppThemes.primaryBlue,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'タイマーを選択してください',
            style: TextStyle(
              fontSize: 18,
              color: AppThemes.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerType(BuildContext context) {
    String typeText;
    Color typeColor;

    switch (timer!.type) {
      case timer_entity.TimerType.pomodoro:
        typeText = 'ポモドーロ';
        typeColor = AppThemes.primaryBlue;
        break;
      case timer_entity.TimerType.shortBreak:
        typeText = '短い休憩';
        typeColor = AppThemes.successColor;
        break;
      case timer_entity.TimerType.longBreak:
        typeText = '長い休憩';
        typeColor = AppThemes.darkBlue;
        break;
      case timer_entity.TimerType.custom:
        typeText = 'カスタム';
        typeColor = AppThemes.lightBlue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: typeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: typeColor.withValues(alpha: 0.5), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTypeIcon(), color: typeColor, size: 20),
          const SizedBox(width: 8),
          Text(
            typeText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: typeColor,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (timer!.type) {
      case timer_entity.TimerType.pomodoro:
        return Icons.work_outline_rounded;
      case timer_entity.TimerType.shortBreak:
        return Icons.coffee_outlined;
      case timer_entity.TimerType.longBreak:
        return Icons.free_breakfast_outlined;
      case timer_entity.TimerType.custom:
        return Icons.settings_outlined;
    }
  }

  Widget _buildCircularTimer(BuildContext context) {
    final progress = timer!.progress;

    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getTimerColor(context).withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景円
          SizedBox(
            width: 250,
            height: 250,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 14,
              backgroundColor: AppThemes.grey100,
              valueColor: AlwaysStoppedAnimation<Color>(AppThemes.grey100),
              strokeCap: StrokeCap.round,
            ),
          ),
          // 進捗円
          SizedBox(
            width: 250,
            height: 250,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 14,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getTimerColor(context),
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeText(BuildContext context) {
    return Text(
      timer!.formattedTime,
      style: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        color: _getTimerColor(context),
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }

  Color _getTimerColor(BuildContext context) {
    switch (timer!.type) {
      case timer_entity.TimerType.pomodoro:
        return AppThemes.primaryBlue;
      case timer_entity.TimerType.shortBreak:
        return AppThemes.successColor;
      case timer_entity.TimerType.longBreak:
          return AppThemes.darkBlue;
      case timer_entity.TimerType.custom:
        return AppThemes.lightBlue;
    }
  }
}
