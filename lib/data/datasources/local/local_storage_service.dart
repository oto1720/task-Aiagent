// lib/data/datasources/local/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/domain/entities/personal_schedule.dart';

part 'local_storage_service.g.dart';

class LocalStorageService {
  static const String _tasksKey = 'tasks';
  static const String _schedulesKey = 'schedules';
  static const String _personalSchedulesKey = 'personal_schedules';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> init() async {
    // 明示的初期化（任意）
    _prefs = await SharedPreferences.getInstance();
  }

  // タスク関連のメソッド
  Future<List<Task>> getTasks() async {
    final prefs = await _getPrefs();
    final tasksJson = prefs.getString(_tasksKey);
    if (tasksJson == null) return [];

    final List<dynamic> tasksList = json.decode(tasksJson);
    return tasksList.map((taskJson) => Task.fromJson(taskJson)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await _getPrefs();
    final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks(tasks);
  }

  // スケジュール関連のメソッド
  Future<List<DailySchedule>> getSchedules() async {
    final prefs = await _getPrefs();
    final schedulesJson = prefs.getString(_schedulesKey);
    if (schedulesJson == null) return [];

    final List<dynamic> schedulesList = json.decode(schedulesJson);
    return schedulesList
        .map((scheduleJson) => DailySchedule.fromJson(scheduleJson))
        .toList();
  }

  Future<void> saveSchedules(List<DailySchedule> schedules) async {
    final prefs = await _getPrefs();
    final schedulesJson = json.encode(
      schedules.map((schedule) => schedule.toJson()).toList(),
    );
    await prefs.setString(_schedulesKey, schedulesJson);
  }

  Future<void> addSchedule(DailySchedule schedule) async {
    final schedules = await getSchedules();
    // 同じ日付のスケジュールがあれば置き換える
    schedules.removeWhere((s) => 
        s.date.year == schedule.date.year &&
        s.date.month == schedule.date.month &&
        s.date.day == schedule.date.day);
    schedules.add(schedule);
    await saveSchedules(schedules);
  }

  Future<DailySchedule?> getScheduleForDate(DateTime date) async {
    final schedules = await getSchedules();
    try {
      return schedules.firstWhere((schedule) =>
          schedule.date.year == date.year &&
          schedule.date.month == date.month &&
          schedule.date.day == date.day);
    } catch (e) {
      return null;
    }
  }

  // 個人スケジュール関連のメソッド
  Future<List<PersonalSchedule>> getPersonalSchedules() async {
    final prefs = await _getPrefs();
    final personalSchedulesJson = prefs.getString(_personalSchedulesKey);
    if (personalSchedulesJson == null) return [];

    final List<dynamic> schedulesList = json.decode(personalSchedulesJson);
    return schedulesList
        .map((scheduleJson) => PersonalSchedule.fromJson(scheduleJson))
        .toList();
  }

  Future<void> savePersonalSchedules(List<PersonalSchedule> schedules) async {
    final prefs = await _getPrefs();
    final schedulesJson = json.encode(
      schedules.map((schedule) => schedule.toJson()).toList(),
    );
    await prefs.setString(_personalSchedulesKey, schedulesJson);
  }

  Future<void> addPersonalSchedule(PersonalSchedule schedule) async {
    final schedules = await getPersonalSchedules();
    schedules.add(schedule);
    await savePersonalSchedules(schedules);
  }

  Future<void> updatePersonalSchedule(PersonalSchedule schedule) async {
    final schedules = await getPersonalSchedules();
    final index = schedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      schedules[index] = schedule;
      await savePersonalSchedules(schedules);
    }
  }

  Future<void> deletePersonalSchedule(String scheduleId) async {
    final schedules = await getPersonalSchedules();
    schedules.removeWhere((schedule) => schedule.id == scheduleId);
    await savePersonalSchedules(schedules);
  }

  Future<List<PersonalSchedule>> getPersonalSchedulesForDate(DateTime date) async {
    final schedules = await getPersonalSchedules();
    return schedules.where((schedule) =>
        schedule.date.year == date.year &&
        schedule.date.month == date.month &&
        schedule.date.day == date.day).toList();
  }

  // 汎用メソッド
  Future<Map<String, dynamic>?> getData(String key) async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<void> saveData(String key, Map<String, dynamic> data) async {
    final prefs = await _getPrefs();
    final jsonString = json.encode(data);
    await prefs.setString(key, jsonString);
  }

  Future<void> deleteData(String key) async {
    final prefs = await _getPrefs();
    await prefs.remove(key);
  }

  Future<List<Map<String, dynamic>>> getListData(String key) async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];
    final List<dynamic> list = json.decode(jsonString);
    return list.map((item) => item as Map<String, dynamic>).toList();
  }

  Future<void> saveListData(String key, List<Map<String, dynamic>> data) async {
    final prefs = await _getPrefs();
    final jsonString = json.encode(data);
    await prefs.setString(key, jsonString);
  }
}

@riverpod
LocalStorageService localStorageService(Ref ref) {
  return LocalStorageService();
}