import 'package:flutter/material.dart';
import 'package:task_aiagent/core/constant/themes.dart';
import 'package:task_aiagent/domain/entities/timer.dart' as timer_entity;

/// 実行中のタイマーセクション
///
/// ホーム画面用のコンパクトなタイマー表示
class ActiveTimerSection extends StatelessWidget {
  final timer_entity.Timer? timer;
  final String? currentTaskName;
  final VoidCallback? onStart;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onAddTime;

  const ActiveTimerSection({
    super.key,
    this.timer,
    this.currentTaskName,
    this.onStart,
    this.onPause,
    this.onResume,
    this.onPrevious,
    this.onNext,
    this.onAddTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            AppThemes.paleBlue.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppThemes.primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemes.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // セクションヘッダー
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: AppThemes.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '実行中のタイマー',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // タイマー表示
          if (timer != null) ...[
            // タイマータイプ表示
            _buildTimerTypeLabel(),
            const SizedBox(height: 16),

            // 円形タイマー
            _buildCircularTimer(),
            const SizedBox(height: 16),

            // 時間表示
            Text(
              timer!.formattedTime,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _getTimerColor(),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 8),

            // 現在実行中のタスク名
            if (currentTaskName != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppThemes.grey100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentTaskName!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppThemes.secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // コントロールボタン
            _buildControls(),
          ] else
            _buildNoTimerState(),
        ],
      ),
    );
  }

  Widget _buildTimerTypeLabel() {
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: typeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: typeColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        typeText,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: typeColor,
        ),
      ),
    );
  }

  Widget _buildCircularTimer() {
    final progress = timer!.progress;

    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景円
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 12,
              backgroundColor: AppThemes.grey100,
              valueColor: AlwaysStoppedAnimation<Color>(AppThemes.grey100),
              strokeCap: StrokeCap.round,
            ),
          ),
          // 進捗円
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor()),
              strokeCap: StrokeCap.round,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    final isRunning = timer!.state == timer_entity.TimerState.running;
    final isPaused = timer!.state == timer_entity.TimerState.paused;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 前のセッションボタン
        _buildControlButton(
          icon: Icons.skip_previous,
          onPressed: onPrevious,
          tooltip: '前のセッション',
        ),
        const SizedBox(width: 16),

        // メインコントロールボタン
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _getTimerColor().withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: isRunning
                ? onPause
                : (isPaused ? onResume : onStart),
            backgroundColor: _getTimerColor(),
            elevation: 0,
            child: Icon(
              isRunning ? Icons.pause : Icons.play_arrow,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),

        // 次のセッションボタン
        _buildControlButton(
          icon: Icons.skip_next,
          onPressed: onNext,
          tooltip: '次のセッション',
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemes.grey100,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppThemes.grey300,
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 24,
        tooltip: tooltip,
        color: AppThemes.grey600,
      ),
    );
  }

  Widget _buildNoTimerState() {
    return Column(
      children: [
        Icon(
          Icons.timer_off_outlined,
          size: 64,
          color: AppThemes.grey400,
        ),
        const SizedBox(height: 16),
        Text(
          'タイマーを開始してください',
          style: TextStyle(
            fontSize: 16,
            color: AppThemes.secondaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.play_arrow),
          label: const Text('タイマーを開始'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppThemes.primaryBlue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Color _getTimerColor() {
    if (timer == null) return AppThemes.primaryBlue;

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
