import 'package:task_aiagent/domain/entities/personal_schedule.dart';

abstract class PersonalScheduleRepository {
  Future<List<PersonalSchedule>> getPersonalSchedules();
  Future<void> addPersonalSchedule(PersonalSchedule schedule);
  Future<void> updatePersonalSchedule(PersonalSchedule schedule);
  Future<void> deletePersonalSchedule(String scheduleId);
  Future<List<PersonalSchedule>> getPersonalSchedulesForDate(DateTime date);
}