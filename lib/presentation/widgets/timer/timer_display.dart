// lib/presentation/widgets/timer/timer_display.dart

import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/timer.dart' as timer_entity;

/// タイマー表示ウィジェット
class TimerDisplay extends StatelessWidget {
  final timer_entity.Timer? timer;

  const TimerDisplay({
    super.key,
    this.timer,
  });

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
          Icon(
            Icons.timer_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'タイマーを選択してください',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
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
        typeColor = Theme.of(context).primaryColor;
        break;
      case timer_entity.TimerType.shortBreak:
        typeText = '短い休憩';
        typeColor = Colors.green;
        break;
      case timer_entity.TimerType.longBreak:
        typeText = '長い休憩';
        typeColor = Colors.blue;
        break;
      case timer_entity.TimerType.custom:
        typeText = 'カスタム';
        typeColor = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: typeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: typeColor),
      ),
      child: Text(
        typeText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: typeColor,
        ),
      ),
    );
  }

  Widget _buildCircularTimer(BuildContext context) {
    final progress = timer!.progress;

    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景円
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 12,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.grey[200]!,
            ),
          ),
          // 進捗円
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 12,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getTimerColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeText(BuildContext context) {
    return Text(
      timer!.formattedTime,
      style: const TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }

  Color _getTimerColor(BuildContext context) {
    switch (timer!.type) {
      case timer_entity.TimerType.pomodoro:
        return Theme.of(context).primaryColor;
      case timer_entity.TimerType.shortBreak:
        return Colors.green;
      case timer_entity.TimerType.longBreak:
        return Colors.blue;
      case timer_entity.TimerType.custom:
        return Colors.orange;
    }
  }
}
