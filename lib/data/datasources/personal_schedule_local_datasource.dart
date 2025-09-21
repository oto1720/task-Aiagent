import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_aiagent/domain/entities/personal_schedule.dart';
import 'package:task_aiagent/core/error/failures.dart';

abstract class PersonalScheduleLocalDataSource {
  Future<List<PersonalSchedule>> getAllPersonalSchedules();
  Future<void> savePersonalSchedules(List<PersonalSchedule> schedules);
  Future<void> savePersonalSchedule(PersonalSchedule schedule);
  Future<void> deletePersonalSchedule(String scheduleId);
  Future<List<PersonalSchedule>> getPersonalSchedulesForDate(DateTime date);
}

class PersonalScheduleLocalDataSourceImpl implements PersonalScheduleLocalDataSource {
  static const String _personalSchedulesKey = 'personal_schedules';
  final SharedPreferences _sharedPreferences;

  PersonalScheduleLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<List<PersonalSchedule>> getAllPersonalSchedules() async {
    try {
      final personalSchedulesJson = _sharedPreferences.getString(_personalSchedulesKey);
      if (personalSchedulesJson == null) return [];

      final List<dynamic> schedulesList = json.decode(personalSchedulesJson);
      return schedulesList
          .map((scheduleJson) => PersonalSchedule.fromJson(scheduleJson))
          .toList();
    } catch (e) {
      throw CacheFailure('個人スケジュールの取得に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<void> savePersonalSchedules(List<PersonalSchedule> schedules) async {
    try {
      final schedulesJson = json.encode(
        schedules.map((schedule) => schedule.toJson()).toList(),
      );
      await _sharedPreferences.setString(_personalSchedulesKey, schedulesJson);
    } catch (e) {
      throw CacheFailure('個人スケジュールの保存に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<void> savePersonalSchedule(PersonalSchedule schedule) async {
    try {
      final schedules = await getAllPersonalSchedules();
      final index = schedules.indexWhere((s) => s.id == schedule.id);

      if (index != -1) {
        schedules[index] = schedule;
      } else {
        schedules.add(schedule);
      }

      await savePersonalSchedules(schedules);
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure('個人スケジュールの保存に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePersonalSchedule(String scheduleId) async {
    try {
      final schedules = await getAllPersonalSchedules();
      schedules.removeWhere((schedule) => schedule.id == scheduleId);
      await savePersonalSchedules(schedules);
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure('個人スケジュールの削除に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<List<PersonalSchedule>> getPersonalSchedulesForDate(DateTime date) async {
    try {
      final schedules = await getAllPersonalSchedules();
      return schedules.where((schedule) =>
          schedule.date.year == date.year &&
          schedule.date.month == date.month &&
          schedule.date.day == date.day).toList();
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure('指定日の個人スケジュール取得に失敗しました: ${e.toString()}');
    }
  }
}