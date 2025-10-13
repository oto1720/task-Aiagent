// lib/presentation/providers/timer/timer_providers.dart

import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/domain/repositories/timer_repository.dart';
import 'package:task_aiagent/domain/usecases/timer/start_timer_usecase.dart';
import 'package:task_aiagent/domain/usecases/timer/pause_timer_usecase.dart';
import 'package:task_aiagent/domain/usecases/timer/resume_timer_usecase.dart';
import 'package:task_aiagent/domain/usecases/timer/complete_timer_usecase.dart';
import 'package:task_aiagent/domain/usecases/timer/reset_timer_usecase.dart';
import 'package:task_aiagent/domain/usecases/timer/update_timer_usecase.dart';
import 'package:task_aiagent/data/repositories/timer_repository_impl.dart';
import 'package:task_aiagent/data/datasources/timer/timer_local_datasource.dart';
import 'package:task_aiagent/data/datasources/local/local_storage_service.dart';
import 'package:uuid/uuid.dart';

part 'timer_providers.g.dart';

// Data層のプロバイダー
@riverpod
TimerLocalDataSource timerLocalDataSource(Ref ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return TimerLocalDataSource(storage: localStorage);
}

@riverpod
TimerRepository timerRepository(Ref ref) {
  final dataSource = ref.watch(timerLocalDataSourceProvider);
  return TimerRepositoryImpl(localDataSource: dataSource);
}

// UseCase層のプロバイダー
@riverpod
StartTimerUseCase startTimerUseCase(Ref ref) {
  final repository = ref.watch(timerRepositoryProvider);
  return StartTimerUseCase(repository);
}

@riverpod
PauseTimerUseCase pauseTimerUseCase(Ref ref) {
  final repository = ref.watch(timerRepositoryProvider);
  return PauseTimerUseCase(repository);
}

@riverpod
ResumeTimerUseCase resumeTimerUseCase(Ref ref) {
  final repository = ref.watch(timerRepositoryProvider);
  return ResumeTimerUseCase(repository);
}

@riverpod
CompleteTimerUseCase completeTimerUseCase(Ref ref) {
  final repository = ref.watch(timerRepositoryProvider);
  return CompleteTimerUseCase(repository);
}

@riverpod
ResetTimerUseCase resetTimerUseCase(Ref ref) {
  final repository = ref.watch(timerRepositoryProvider);
  return ResetTimerUseCase(repository);
}

@riverpod
UpdateTimerUseCase updateTimerUseCase(Ref ref) {
  final repository = ref.watch(timerRepositoryProvider);
  return UpdateTimerUseCase(repository);
}

// 今日のポモドーロ数を取得するプロバイダー
@riverpod
Future<int> todayPomodoroCount(Ref ref) async {
  final repository = ref.watch(timerRepositoryProvider);
  final result = await repository.getTodayPomodoroCount();

  return result.fold((failure) => 0, (count) => count);
}

/// タイマー状態管理プロバイダー
@riverpod
class TimerNotifier extends _$TimerNotifier {
  StreamSubscription<void>? _timerSubscription;

  @override
  Future<Timer?> build() async {
    ref.onDispose(() {
      _timerSubscription?.cancel();
    });

    final repository = ref.watch(timerRepositoryProvider);
    final result = await repository.getCurrentTimer();

    return result.fold((failure) => null, (timer) => timer);
  }

  /// 新しいタイマーを作成
  Future<void> createTimer({
    required TimerType type,
    int? durationMinutes,
    String? taskId,
  }) async {
    Timer newTimer;

    switch (type) {
      case TimerType.pomodoro:
        final pomodoroCount = await ref.read(todayPomodoroCountProvider.future);
        newTimer = Timer.pomodoro(
          id: const Uuid().v4(),
          taskId: taskId,
          pomodoroCount: pomodoroCount,
        );
        break;
      case TimerType.shortBreak:
        final pomodoroCount = await ref.read(todayPomodoroCountProvider.future);
        newTimer = Timer.shortBreak(
          id: const Uuid().v4(),
          pomodoroCount: pomodoroCount,
        );
        break;
      case TimerType.longBreak:
        final pomodoroCount = await ref.read(todayPomodoroCountProvider.future);
        newTimer = Timer.longBreak(
          id: const Uuid().v4(),
          pomodoroCount: pomodoroCount,
        );
        break;
      case TimerType.custom:
        newTimer = Timer.custom(
          id: const Uuid().v4(),
          durationMinutes: durationMinutes ?? 25,
          taskId: taskId,
        );
        break;
    }

    state = AsyncValue.data(newTimer);
  }

  /// タイマーを開始
  Future<void> start() async {
    final currentTimer = state.value;
    if (currentTimer == null) return;

    final useCase = ref.read(startTimerUseCaseProvider);
    final result = await useCase(currentTimer);

    result.fold((failure) => throw Exception(failure.message), (timer) {
      state = AsyncValue.data(timer);
      _startCountdown();
    });
  }

  /// タイマーを一時停止
  Future<void> pause() async {
    final currentTimer = state.value;
    if (currentTimer == null) return;

    _timerSubscription?.cancel();

    final useCase = ref.read(pauseTimerUseCaseProvider);
    final result = await useCase(currentTimer);

    result.fold(
      (failure) => throw Exception(failure.message),
      (timer) => state = AsyncValue.data(timer),
    );
  }

  /// タイマーを再開
  Future<void> resume() async {
    final currentTimer = state.value;
    if (currentTimer == null) return;

    final useCase = ref.read(resumeTimerUseCaseProvider);
    final result = await useCase(currentTimer);

    result.fold((failure) => throw Exception(failure.message), (timer) {
      state = AsyncValue.data(timer);
      _startCountdown();
    });
  }

  /// タイマーをリセット
  Future<void> reset() async {
    final currentTimer = state.value;
    if (currentTimer == null) return;

    _timerSubscription?.cancel();

    final useCase = ref.read(resetTimerUseCaseProvider);
    final result = await useCase(currentTimer);

    result.fold(
      (failure) => throw Exception(failure.message),
      (timer) => state = AsyncValue.data(timer),
    );
  }

  /// タイマーを完了
  Future<void> complete() async {
    final currentTimer = state.value;
    if (currentTimer == null) return;

    _timerSubscription?.cancel();

    final useCase = ref.read(completeTimerUseCaseProvider);
    final result = await useCase(currentTimer);

    result.fold((failure) => throw Exception(failure.message), (timer) {
      state = AsyncValue.data(timer);
      // ポモドーロ数を更新
      ref.invalidate(todayPomodoroCountProvider);
    });
  }

  /// 次のタイマーに移行（ポモドーロサイクル）
  Future<void> nextTimer() async {
    final currentTimer = state.value;
    if (currentTimer == null) return;

    final nextType = currentTimer.nextTimerType;

    await createTimer(type: nextType, taskId: currentTimer.taskId);
  }

  /// カウントダウンを開始
  void _startCountdown() {
    _timerSubscription?.cancel();

    _timerSubscription =
        Stream.periodic(const Duration(seconds: 1), (count) => count).listen((
          _,
        ) async {
          final currentTimer = state.value;
          if (currentTimer == null || !currentTimer.isRunning) {
            _timerSubscription?.cancel();
            return;
          }

          final newRemainingSeconds = currentTimer.remainingSeconds - 1;

          if (newRemainingSeconds <= 0) {
            await complete();
            return;
          }

          final useCase = ref.read(updateTimerUseCaseProvider);
          final result = await useCase(currentTimer, newRemainingSeconds);

          result.fold(
            (failure) => throw Exception(failure.message),
            (timer) => state = AsyncValue.data(timer),
          );
        });
  }
}
