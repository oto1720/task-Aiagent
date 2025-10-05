// lib/data/repositories/timer_repository_impl.dart

import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/domain/repositories/timer_repository.dart';
import 'package:task_aiagent/data/datasources/timer/timer_local_datasource.dart';
import 'package:task_aiagent/core/utils/result.dart';
import 'package:task_aiagent/core/error/failures.dart';

/// タイマーリポジトリの実装
class TimerRepositoryImpl implements TimerRepository {
  final TimerLocalDataSource _localDataSource;

  TimerRepositoryImpl({required TimerLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  AsyncResult<Timer?> getCurrentTimer() async {
    try {
      final timer = await _localDataSource.getCurrentTimer();
      return Success(timer);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(
        UnexpectedFailure('現在のタイマー取得中に予期しないエラーが発生しました: ${e.toString()}'),
      );
    }
  }

  @override
  AsyncResult<Timer> saveTimer(Timer timer) async {
    try {
      await _localDataSource.saveCurrentTimer(timer);

      // 完了したタイマーは履歴に追加
      if (timer.state == TimerState.completed) {
        await _localDataSource.addToHistory(timer);
      }

      return Success(timer);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(
        UnexpectedFailure('タイマー保存中にエラーが発生しました: ${e.toString()}'),
      );
    }
  }

  @override
  AsyncResult<void> deleteTimer(String timerId) async {
    try {
      await _localDataSource.deleteCurrentTimer();
      return Success(null);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(
        UnexpectedFailure('タイマー削除中にエラーが発生しました: ${e.toString()}'),
      );
    }
  }

  @override
  AsyncResult<List<Timer>> getTimerHistory({int limit = 10}) async {
    try {
      final history = await _localDataSource.getTimerHistory(limit: limit);
      return Success(history);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(
        UnexpectedFailure('タイマー履歴取得中にエラーが発生しました: ${e.toString()}'),
      );
    }
  }

  @override
  AsyncResult<List<Timer>> getCompletedTimers({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final timers = await _localDataSource.getCompletedTimers(
        startDate: startDate,
        endDate: endDate,
      );
      return Success(timers);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(
        UnexpectedFailure('完了タイマー取得中にエラーが発生しました: ${e.toString()}'),
      );
    }
  }

  @override
  AsyncResult<List<Timer>> getTimersByTaskId(String taskId) async {
    try {
      if (taskId.isEmpty) {
        return ResultFailure(ValidationFailure('タスクIDが無効です'));
      }

      final timers = await _localDataSource.getTimersByTaskId(taskId);
      return Success(timers);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(
        UnexpectedFailure('タスク別タイマー取得中にエラーが発生しました: ${e.toString()}'),
      );
    }
  }

  @override
  AsyncResult<int> getTodayPomodoroCount() async {
    try {
      final count = await _localDataSource.getTodayPomodoroCount();
      return Success(count);
    } on CacheFailure catch (e) {
      return ResultFailure(e);
    } catch (e) {
      return ResultFailure(
        UnexpectedFailure('今日のポモドーロ数取得中にエラーが発生しました: ${e.toString()}'),
      );
    }
  }
}
