import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/core/error/failures.dart';

abstract class ScheduleLocalDataSource {
  Future<List<DailySchedule>> getAllSchedules();
  Future<void> saveSchedules(List<DailySchedule> schedules);
  Future<void> saveSchedule(DailySchedule schedule);
  Future<DailySchedule?> getScheduleForDate(DateTime date);
}

class ScheduleLocalDataSourceImpl implements ScheduleLocalDataSource {
  static const String _schedulesKey = 'schedules';
  final SharedPreferences _sharedPreferences;

  ScheduleLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<List<DailySchedule>> getAllSchedules() async {
    try {
      final schedulesJson = _sharedPreferences.getString(_schedulesKey);
      if (schedulesJson == null) return [];

      final List<dynamic> schedulesList = json.decode(schedulesJson);
      return schedulesList
          .map((scheduleJson) => DailySchedule.fromJson(scheduleJson))
          .toList();
    } catch (e) {
      throw CacheFailure('スケジュールの取得に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<void> saveSchedules(List<DailySchedule> schedules) async {
    try {
      final schedulesJson = json.encode(
        schedules.map((schedule) => schedule.toJson()).toList(),
      );
      await _sharedPreferences.setString(_schedulesKey, schedulesJson);
    } catch (e) {
      throw CacheFailure('スケジュールの保存に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<void> saveSchedule(DailySchedule schedule) async {
    try {
      final schedules = await getAllSchedules();

      // 同じ日付のスケジュールがあれば置き換える
      schedules.removeWhere((s) =>
          s.date.year == schedule.date.year &&
          s.date.month == schedule.date.month &&
          s.date.day == schedule.date.day);

      schedules.add(schedule);
      await saveSchedules(schedules);
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure('スケジュールの保存に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<DailySchedule?> getScheduleForDate(DateTime date) async {
    try {
      final schedules = await getAllSchedules();
      return schedules
          .where((schedule) =>
              schedule.date.year == date.year &&
              schedule.date.month == date.month &&
              schedule.date.day == date.day)
          .firstOrNull;
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure('指定日のスケジュール取得に失敗しました: ${e.toString()}');
    }
  }
}