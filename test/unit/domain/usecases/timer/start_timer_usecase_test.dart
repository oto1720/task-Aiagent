// test/unit/domain/usecases/timer/start_timer_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/domain/repositories/timer_repository.dart';
import 'package:task_aiagent/domain/usecases/timer/start_timer_usecase.dart';
import 'package:task_aiagent/core/utils/result.dart';

class MockTimerRepository extends Mock implements TimerRepository {}

void main() {
  late StartTimerUseCase useCase;
  late MockTimerRepository mockRepository;

  setUp(() {
    mockRepository = MockTimerRepository();
    useCase = StartTimerUseCase(mockRepository);
  });


  group('StartTimerUseCase', () {
    test('待機中のタイマーを開始できる', () async {
      // arrange
      final idleTimer = Timer.pomodoro(id: 'test-id');
      final runningTimer = idleTimer.copyWith(
        state: TimerState.running,
        startedAt: DateTime.now(),
      );

      when(mockRepository.saveTimer(idleTimer))
          .thenAnswer((_) async => Success(runningTimer));

      // act
      final result = await useCase(idleTimer);

      // assert
      expect(result.isSuccess, true);
      result.fold(
        (failure) => fail('Should be success'),
        (timer) {
          expect(timer.state, TimerState.running);
          expect(timer.startedAt, isNotNull);
        },
      );

      verify(mockRepository.saveTimer(idleTimer)).called(1);
    });

    test('既に実行中のタイマーは開始できない', () async {
      // arrange
      final runningTimer = Timer.pomodoro(id: 'test-id')
          .copyWith(state: TimerState.running);

      // act
      final result = await useCase(runningTimer);

      // assert
      expect(result.isSuccess, false);
      result.fold(
        (failure) => expect(failure.message, contains('already running')),
        (timer) => fail('Should be failure'),
      );

      verifyNever(mockRepository.saveTimer(runningTimer));
    });
  });
}
