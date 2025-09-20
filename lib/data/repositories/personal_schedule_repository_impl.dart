import 'package:task_aiagent/domain/entities/personal_schedule.dart';
import 'package:task_aiagent/domain/repositories/personal_schedule_repository.dart';
import 'package:task_aiagent/data/datasources/local/local_storage_service.dart';

class PersonalScheduleRepositoryImpl implements PersonalScheduleRepository {
  final LocalStorageService _localStorageService;

  PersonalScheduleRepositoryImpl(this._localStorageService);

  @override
  Future<List<PersonalSchedule>> getPersonalSchedules() async {
    try {
      return await _localStorageService.getPersonalSchedules();
    } catch (e) {
      print('Error getting personal schedules: $e');
      return [];
    }
  }

  @override
  Future<void> addPersonalSchedule(PersonalSchedule schedule) async {
    try {
      await _localStorageService.addPersonalSchedule(schedule);
    } catch (e) {
      print('Error adding personal schedule: $e');
      throw Exception('Failed to add personal schedule');
    }
  }

  @override
  Future<void> updatePersonalSchedule(PersonalSchedule schedule) async {
    try {
      await _localStorageService.updatePersonalSchedule(schedule);
    } catch (e) {
      print('Error updating personal schedule: $e');
      throw Exception('Failed to update personal schedule');
    }
  }

  @override
  Future<void> deletePersonalSchedule(String scheduleId) async {
    try {
      await _localStorageService.deletePersonalSchedule(scheduleId);
    } catch (e) {
      print('Error deleting personal schedule: $e');
      throw Exception('Failed to delete personal schedule');
    }
  }

  @override
  Future<List<PersonalSchedule>> getPersonalSchedulesForDate(DateTime date) async {
    try {
      return await _localStorageService.getPersonalSchedulesForDate(date);
    } catch (e) {
      print('Error getting personal schedules for date: $e');
      return [];
    }
  }
}