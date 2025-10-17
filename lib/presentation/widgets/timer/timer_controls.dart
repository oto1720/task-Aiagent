// lib/presentation/widgets/timer/timer_controls.dart

import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/timer.dart' as timer_entity;
import 'package:task_aiagent/core/constant/themes.dart';

/// タイマー操作コントロールウィジェット
class TimerControls extends StatelessWidget {
  final timer_entity.Timer? timer;
  final VoidCallback? onStart;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onReset;
  final VoidCallback? onComplete;

  const TimerControls({
    super.key,
    this.timer,
    this.onStart,
    this.onPause,
    this.onResume,
    this.onReset,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (timer == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // リセットボタン
        if (timer!.state != timer_entity.TimerState.idle)
          _buildControlButton(
            icon: Icons.refresh_rounded,
            onPressed: onReset,
            color: AppThemes.grey600,
            tooltip: 'リセット',
          ),
        const SizedBox(width: 24),
        // メインコントロールボタン
        _buildMainButton(context),
        const SizedBox(width: 24),
        // スキップボタン（完了）
        if (timer!.state != timer_entity.TimerState.idle &&
            timer!.state != timer_entity.TimerState.completed)
          _buildControlButton(
            icon: Icons.skip_next_rounded,
            onPressed: onComplete,
            color: AppThemes.darkBlue,
            tooltip: '完了',
          ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 32,
        tooltip: tooltip,
        color: color,
      ),
    );
  }

  Widget _buildMainButton(BuildContext context) {
    final isRunning = timer!.state == timer_entity.TimerState.running;
    final isPaused = timer!.state == timer_entity.TimerState.paused;
    final isIdle = timer!.state == timer_entity.TimerState.idle;
    final isCompleted = timer!.state == timer_entity.TimerState.completed;

    IconData icon;
    VoidCallback? onPressed;
    Color color;

    if (isRunning) {
      icon = Icons.pause_rounded;
      onPressed = onPause;
      color = AppThemes.lightBlue;
    } else if (isPaused) {
      icon = Icons.play_arrow_rounded;
      onPressed = onResume;
      color = AppThemes.successColor;
    } else if (isIdle || isCompleted) {
      icon = Icons.play_arrow_rounded;
      onPressed = onStart;
      color = AppThemes.primaryBlue;
    } else {
      icon = Icons.play_arrow_rounded;
      onPressed = null;
      color = AppThemes.grey400;
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: color,
        elevation: 0,
        child: Icon(icon, size: 40, color: Colors.white),
      ),
    );
  }
}
