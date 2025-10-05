// lib/data/datasources/timer/timer_local_datasource.dart

import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/data/datasources/local/local_storage_service.dart';

/// タイマーのローカルデータソース
///
/// タイマーデータのローカルストレージへの保存・取得を担当
class TimerLocalDataSource {
  final LocalStorageService _storage;
  static const String _currentTimerKey = 'current_timer';
  static const String _timerHistoryKey = 'timer_history';

  TimerLocalDataSource({required LocalStorageService storage})
      : _storage = storage;

  /// 現在のタイマーを取得
  Future<Timer?> getCurrentTimer() async {
    final data = await _storage.getData(_currentTimerKey);
    if (data == null) return null;
    return Timer.fromJson(data);
  }

  /// 現在のタイマーを保存
  Future<void> saveCurrentTimer(Timer timer) async {
    await _storage.saveData(_currentTimerKey, timer.toJson());
  }

  /// 現在のタイマーを削除
  Future<void> deleteCurrentTimer() async {
    await _storage.deleteData(_currentTimerKey);
  }

  /// タイマー履歴を取得
  Future<List<Timer>> getTimerHistory({int limit = 10}) async {
    final data = await _storage.getListData(_timerHistoryKey);
    if (data.isEmpty) return [];

    final timers = data.map((json) => Timer.fromJson(json)).toList();

    // 新しい順にソート
    timers.sort((a, b) {
      final aTime = a.completedAt ?? a.startedAt ?? DateTime(0);
      final bTime = b.completedAt ?? b.startedAt ?? DateTime(0);
      return bTime.compareTo(aTime);
    });

    return timers.take(limit).toList();
  }

  /// タイマー履歴に追加
  Future<void> addToHistory(Timer timer) async {
    final history = await getTimerHistory(limit: 100);
    history.insert(0, timer);

    // 最新100件のみ保持
    final limitedHistory = history.take(100).toList();
    await _storage.saveListData(
      _timerHistoryKey,
      limitedHistory.map((t) => t.toJson()).toList(),
    );
  }

  /// 完了したタイマーを取得
  Future<List<Timer>> getCompletedTimers({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final history = await getTimerHistory(limit: 100);

    return history.where((timer) {
      if (timer.state != TimerState.completed) return false;
      if (timer.completedAt == null) return false;

      if (startDate != null && timer.completedAt!.isBefore(startDate)) {
        return false;
      }

      if (endDate != null && timer.completedAt!.isAfter(endDate)) {
        return false;
      }

      return true;
    }).toList();
  }

  /// 特定のタスクに関連するタイマーを取得
  Future<List<Timer>> getTimersByTaskId(String taskId) async {
    final history = await getTimerHistory(limit: 100);
    return history.where((timer) => timer.taskId == taskId).toList();
  }

  /// 今日完了したポモドーロ数を取得
  Future<int> getTodayPomodoroCount() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final completedTimers = await getCompletedTimers(
      startDate: today,
      endDate: tomorrow,
    );

    return completedTimers
        .where((timer) => timer.type == TimerType.pomodoro)
        .length;
  }
}
