import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_aiagent/domain/entities/personal_schedule.dart';
import 'package:task_aiagent/domain/repositories/personal_schedule_repository.dart';
import 'package:task_aiagent/data/repositories/personal_schedule_repository_impl.dart';
import 'package:task_aiagent/presentation/providers/task_provider.dart';

part 'personal_schedule_provider.g.dart';

// PersonalScheduleRepositoryのプロバイダー
@riverpod
PersonalScheduleRepository personalScheduleRepository(Ref ref) {
  return PersonalScheduleRepositoryImpl(ref.read(localStorageServiceProvider));
}

@riverpod
class PersonalScheduleList extends _$PersonalScheduleList {
  @override
  List<PersonalSchedule> build() {
    _loadSchedules();
    return [];
  }

  Future<void> _loadSchedules() async {
    try {
      final repository = ref.read(personalScheduleRepositoryProvider);
      final schedules = await repository.getPersonalSchedules();
      state = schedules;
    } catch (e) {
      print('Error loading personal schedules: $e');
    }
  }

  Future<void> addSchedule(PersonalSchedule schedule) async {
    try {
      final repository = ref.read(personalScheduleRepositoryProvider);
      await repository.addPersonalSchedule(schedule);
      state = [...state, schedule];
    } catch (e) {
      print('Error adding personal schedule: $e');
    }
  }

  Future<void> updateSchedule(PersonalSchedule updatedSchedule) async {
    try {
      final repository = ref.read(personalScheduleRepositoryProvider);
      await repository.updatePersonalSchedule(updatedSchedule);
      state = state.map((schedule) {
        return schedule.id == updatedSchedule.id ? updatedSchedule : schedule;
      }).toList();
    } catch (e) {
      print('Error updating personal schedule: $e');
    }
  }

  Future<void> removeSchedule(String scheduleId) async {
    try {
      final repository = ref.read(personalScheduleRepositoryProvider);
      await repository.deletePersonalSchedule(scheduleId);
      state = state.where((schedule) => schedule.id != scheduleId).toList();
    } catch (e) {
      print('Error removing personal schedule: $e');
    }
  }
}

@riverpod
Map<DateTime, List<PersonalSchedule>> personalScheduleEvents(Ref ref) {
  final schedules = ref.watch(personalScheduleListProvider);
  final events = <DateTime, List<PersonalSchedule>>{};

  for (final schedule in schedules) {
    final dateKey = DateTime.utc(
      schedule.date.year,
      schedule.date.month,
      schedule.date.day,
    );

    if (events[dateKey] == null) {
      events[dateKey] = [];
    }
    events[dateKey]!.add(schedule);
  }

  for (final key in events.keys) {
    events[key]!.sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  return events;
}

@riverpod
List<PersonalSchedule> personalSchedulesForDay(Ref ref, DateTime day) {
  final events = ref.watch(personalScheduleEventsProvider);
  final dateKey = DateTime.utc(day.year, day.month, day.day);
  return events[dateKey] ?? [];
}

@riverpod
List<PersonalSchedule> todayPersonalSchedules(Ref ref) {
  final today = DateTime.now();
  return ref.watch(personalSchedulesForDayProvider(today));
}