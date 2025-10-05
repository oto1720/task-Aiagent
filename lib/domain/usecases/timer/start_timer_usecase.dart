// lib/domain/usecases/timer/start_timer_usecase.dart

import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/domain/repositories/timer_repository.dart';
import 'package:task_aiagent/core/utils/result.dart';
import 'package:task_aiagent/core/error/failures.dart';

/// タイマーを開始するユースケース
class StartTimerUseCase {
  final TimerRepository _repository;

  StartTimerUseCase(this._repository);

  /// タイマーを開始
  ///
  /// [timer] 開始するタイマー
  /// Returns: 開始されたタイマー
  AsyncResult<Timer> call(Timer timer) async {
    // タイマーが既に実行中でないことを確認
    if (timer.isRunning) {
      return ResultFailure(ValidationFailure('Timer is already running'));
    }

    final startedTimer = timer.copyWith(
      state: TimerState.running,
      startedAt: DateTime.now(),
    );

    return await _repository.saveTimer(startedTimer);
  }
}
