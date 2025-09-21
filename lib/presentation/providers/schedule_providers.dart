
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_aiagent/domain/entities/schedule.dart';
import 'package:task_aiagent/domain/usecases/schedule/generate_optimal_schedule_usecase.dart';
import 'package:task_aiagent/data/datasources/schedule_local_datasource.dart';
import 'package:task_aiagent/presentation/providers/task_providers.dart';

part 'schedule_providers.g.dart';

// Data層のプロバイダー
@riverpod
ScheduleLocalDataSource scheduleLocalDataSource(Ref ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return sharedPrefs.when(
    data: (prefs) => ScheduleLocalDataSourceImpl(sharedPreferences: prefs),
    loading: () => throw Exception('SharedPreferences not ready'),
    error: (error, stack) => throw error,
  );
}

// UseCase層のプロバイダー
@riverpod
GenerateOptimalScheduleUseCase generateOptimalScheduleUseCase(
    Ref ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return GenerateOptimalScheduleUseCase(taskRepository: taskRepository);
}

// 状態管理のプロバイダー
@riverpod
class TodaySchedule extends _$TodaySchedule {
  @override
  Future<DailySchedule?> build() async {
    final dataSource = ref.watch(scheduleLocalDataSourceProvider);
    final today = DateTime.now();

    try {
      return await dataSource.getScheduleForDate(today);
    } catch (e) {
      // スケジュールが存在しない場合はnullを返す
      return null;
    }
  }

  Future<void> generateTodaySchedule({
    int workingHoursPerDay = 8,
    int breakIntervalMinutes = 60,
    int breakDurationMinutes = 15,
  }) async {
    final generateUseCase = ref.read(generateOptimalScheduleUseCaseProvider);
    final dataSource = ref.read(scheduleLocalDataSourceProvider);
    final today = DateTime.now();

    try {
      final result = await generateUseCase.execute(
        targetDate: today,
        workingHoursPerDay: workingHoursPerDay,
        breakIntervalMinutes: breakIntervalMinutes,
        breakDurationMinutes: breakDurationMinutes,
      );

      result.fold(
        (failure) => throw Exception(failure.message),
        (schedule) async {
          // ローカルストレージに保存
          await dataSource.saveSchedule(schedule);

          // 状態を更新
          state = AsyncValue.data(schedule);
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshSchedule() async {
    // 現在の状態をリセットして再生成
    state = const AsyncValue.loading();
    await generateTodaySchedule();
  }

  Future<void> clearSchedule() async {
    try {
      // 今日のスケジュールを削除（実装は必要に応じて）
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// スケジュール関連の計算プロバイダー
@riverpod
int totalWorkingMinutesToday(Ref ref) {
  final schedule = ref.watch(todayScheduleProvider);

  return schedule.when(
    data: (schedule) {
      if (schedule == null) return 0;
      return schedule.items
          .where((item) => item.type == ScheduleItemType.task)
          .fold<int>(0, (sum, item) => sum + (item.estimatedMinutes ?? 0));
    },
    loading: () => 0,
    error: (error, stack) => 0,
  );
}

@riverpod
int remainingTasksCount(Ref ref) {
  final schedule = ref.watch(todayScheduleProvider);

  return schedule.when(
    data: (schedule) {
      if (schedule == null) return 0;
      return schedule.items
          .where((item) => item.type == ScheduleItemType.task)
          .length;
    },
    loading: () => 0,
    error: (error, stack) => 0,
  );
}

@riverpod
List<ScheduleItem> currentScheduleItems(Ref ref) {
  final schedule = ref.watch(todayScheduleProvider);
  final now = DateTime.now();

  return schedule.when(
    data: (schedule) {
      if (schedule == null) return [];

      // 現在時刻以降のスケジュールアイテムを返す
      return schedule.items
          .where((item) => item.endTime.isAfter(now))
          .toList();
    },
    loading: () => [],
    error: (error, stack) => [],
  );
}

@riverpod
ScheduleItem? currentScheduleItem(Ref ref) {
  final schedule = ref.watch(todayScheduleProvider);
  final now = DateTime.now();

  return schedule.when(
    data: (schedule) {
      if (schedule == null) return null;

      // 現在実行中のスケジュールアイテムを返す
      try {
        return schedule.items.firstWhere((item) =>
            item.startTime.isBefore(now) && item.endTime.isAfter(now));
      } catch (e) {
        return null;
      }
    },
    loading: () => null,
    error: (error, stack) => null,
  );
}

@riverpod
ScheduleItem? nextScheduleItem(Ref ref) {
  final schedule = ref.watch(todayScheduleProvider);
  final now = DateTime.now();

  return schedule.when(
    data: (schedule) {
      if (schedule == null) return null;

      // 次のスケジュールアイテムを返す
      final futureItems = schedule.items
          .where((item) => item.startTime.isAfter(now))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      return futureItems.isNotEmpty ? futureItems.first : null;
    },
    loading: () => null,
    error: (error, stack) => null,
  );
}