// lib/presentation/widgets/timer/timer_controls.dart

import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/timer.dart' as timer_entity;

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
          IconButton(
            onPressed: onReset,
            icon: const Icon(Icons.refresh),
            iconSize: 32,
            tooltip: 'リセット',
          ),
        const SizedBox(width: 24),
        // メインコントロールボタン
        _buildMainButton(context),
        const SizedBox(width: 24),
        // スキップボタン（完了）
        if (timer!.state != timer_entity.TimerState.idle &&
            timer!.state != timer_entity.TimerState.completed)
          IconButton(
            onPressed: onComplete,
            icon: const Icon(Icons.skip_next),
            iconSize: 32,
            tooltip: '完了',
          ),
      ],
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
      icon = Icons.pause;
      onPressed = onPause;
      color = Colors.orange;
    } else if (isPaused) {
      icon = Icons.play_arrow;
      onPressed = onResume;
      color = Colors.green;
    } else if (isIdle || isCompleted) {
      icon = Icons.play_arrow;
      onPressed = onStart;
      color = Theme.of(context).primaryColor;
    } else {
      icon = Icons.play_arrow;
      onPressed = null;
      color = Colors.grey;
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color,
      child: Icon(
        icon,
        size: 36,
        color: Colors.white,
      ),
    );
  }
}
