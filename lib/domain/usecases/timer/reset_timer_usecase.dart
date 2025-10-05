// lib/domain/usecases/timer/reset_timer_usecase.dart

import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/domain/repositories/timer_repository.dart';
import 'package:task_aiagent/core/utils/result.dart';

/// タイマーをリセットするユースケース
class ResetTimerUseCase {
  final TimerRepository _repository;

  ResetTimerUseCase(this._repository);

  /// タイマーをリセット
  ///
  /// [timer] リセットするタイマー
  /// Returns: リセットされたタイマー
  AsyncResult<Timer> call(Timer timer) async {
    final resetTimer = timer.copyWith(
      state: TimerState.idle,
      remainingSeconds: timer.durationMinutes * 60,
      startedAt: null,
      pausedAt: null,
      completedAt: null,
    );

    return await _repository.saveTimer(resetTimer);
  }
}
