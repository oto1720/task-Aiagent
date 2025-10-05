// lib/domain/usecases/timer/update_timer_usecase.dart

import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/domain/repositories/timer_repository.dart';
import 'package:task_aiagent/core/utils/result.dart';

/// タイマーを更新するユースケース（残り時間のカウントダウン）
class UpdateTimerUseCase {
  final TimerRepository _repository;

  UpdateTimerUseCase(this._repository);

  /// タイマーの残り時間を更新
  ///
  /// [timer] 更新するタイマー
  /// [remainingSeconds] 新しい残り時間（秒）
  /// Returns: 更新されたタイマー
  AsyncResult<Timer> call(Timer timer, int remainingSeconds) async {
    // 残り時間が0以下になったら完了状態に
    if (remainingSeconds <= 0) {
      return await _repository.saveTimer(
        timer.copyWith(
          state: TimerState.completed,
          remainingSeconds: 0,
          completedAt: DateTime.now(),
        ),
      );
    }

    final updatedTimer = timer.copyWith(
      remainingSeconds: remainingSeconds,
    );

    return await _repository.saveTimer(updatedTimer);
  }
}
