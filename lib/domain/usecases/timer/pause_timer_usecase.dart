// lib/domain/usecases/timer/pause_timer_usecase.dart

import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/domain/repositories/timer_repository.dart';
import 'package:task_aiagent/core/utils/result.dart';
import 'package:task_aiagent/core/error/failures.dart';

/// タイマーを一時停止するユースケース
class PauseTimerUseCase {
  final TimerRepository _repository;

  PauseTimerUseCase(this._repository);

  /// タイマーを一時停止
  ///
  /// [timer] 一時停止するタイマー
  /// Returns: 一時停止されたタイマー
  AsyncResult<Timer> call(Timer timer) async {
    // タイマーが実行中であることを確認
    if (!timer.isRunning) {
      return ResultFailure(ValidationFailure('Timer is not running'));
    }

    final pausedTimer = timer.copyWith(
      state: TimerState.paused,
      pausedAt: DateTime.now(),
    );

    return await _repository.saveTimer(pausedTimer);
  }
}
