// lib/domain/repositories/timer_repository.dart

import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/core/utils/result.dart';

/// タイマーリポジトリのインターフェース
///
/// タイマーの永続化と取得を担当
abstract class TimerRepository {
  /// 現在のタイマーを取得
  AsyncResult<Timer?> getCurrentTimer();

  /// タイマーを保存
  AsyncResult<Timer> saveTimer(Timer timer);

  /// タイマーを削除
  AsyncResult<void> deleteTimer(String timerId);

  /// タイマー履歴を取得
  AsyncResult<List<Timer>> getTimerHistory({int limit = 10});

  /// 完了したタイマーを取得
  AsyncResult<List<Timer>> getCompletedTimers({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// 特定のタスクに関連するタイマーを取得
  AsyncResult<List<Timer>> getTimersByTaskId(String taskId);

  /// ポモドーロ統計を取得（今日完了したポモドーロ数）
  AsyncResult<int> getTodayPomodoroCount();
}
