// lib/domain/usecases/timer/complete_timer_usecase.dart

import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/domain/repositories/timer_repository.dart';
import 'package:task_aiagent/core/utils/result.dart';

/// タイマーを完了するユースケース
class CompleteTimerUseCase {
  final TimerRepository _repository;

  CompleteTimerUseCase(this._repository);

  /// タイマーを完了
  ///
  /// [timer] 完了するタイマー
  /// Returns: 完了したタイマー
  AsyncResult<Timer> call(Timer timer) async {
    final completedTimer = timer.copyWith(
      state: TimerState.completed,
      remainingSeconds: 0,
      completedAt: DateTime.now(),
    );

    return await _repository.saveTimer(completedTimer);
  }
}
