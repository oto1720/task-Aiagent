// lib/domain/usecases/timer/resume_timer_usecase.dart

import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/domain/repositories/timer_repository.dart';
import 'package:task_aiagent/core/utils/result.dart';
import 'package:task_aiagent/core/error/failures.dart';

/// タイマーを再開するユースケース
class ResumeTimerUseCase {
  final TimerRepository _repository;

  ResumeTimerUseCase(this._repository);

  /// タイマーを再開
  ///
  /// [timer] 再開するタイマー
  /// Returns: 再開されたタイマー
  AsyncResult<Timer> call(Timer timer) async {
    // タイマーが一時停止中であることを確認
    if (!timer.isPaused) {
      return ResultFailure(ValidationFailure('Timer is not paused'));
    }

    final resumedTimer = timer.copyWith(
      state: TimerState.running,
      pausedAt: null,
    );

    return await _repository.saveTimer(resumedTimer);
  }
}
