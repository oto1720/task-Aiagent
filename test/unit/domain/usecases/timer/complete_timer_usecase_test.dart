// test/unit/domain/usecases/timer/complete_timer_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_aiagent/domain/entities/timer.dart';
import 'package:task_aiagent/domain/repositories/timer_repository.dart';
import 'package:task_aiagent/domain/usecases/timer/complete_timer_usecase.dart';
import 'package:task_aiagent/core/utils/result.dart';

class MockTimerRepository extends Mock implements TimerRepository {}

void main() {
  late CompleteTimerUseCase useCase;
  late MockTimerRepository mockRepository;

  setUp(() {
    mockRepository = MockTimerRepository();
    useCase = CompleteTimerUseCase(mockRepository);
  });

  

  group('CompleteTimerUseCase', () {
    test('タイマーを完了できる', () async {
      // arrange
      final runningTimer = Timer.pomodoro(id: 'test-id')
          .copyWith(state: TimerState.running);
      final completedTimer = runningTimer.copyWith(
        state: TimerState.completed,
        remainingSeconds: 0,
        completedAt: DateTime.now(),
      );

      when(mockRepository.saveTimer(runningTimer))
          .thenAnswer((_) async => Success(completedTimer));

      // act
      final result = await useCase(runningTimer);

      // assert
      expect(result.isSuccess, true);
      result.fold(
        (failure) => fail('Should be success'),
        (timer) {
          expect(timer.state, TimerState.completed);
          expect(timer.remainingSeconds, 0);
          expect(timer.completedAt, isNotNull);
        },
      );

      verify(mockRepository.saveTimer(runningTimer)).called(1);
    });
  });
}
