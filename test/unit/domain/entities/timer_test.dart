// test/unit/domain/entities/timer_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:task_aiagent/domain/entities/timer.dart';

void main() {
  group('Timer Entity', () {
    group('ファクトリーメソッド', () {
      test('pomodoro - デフォルトのポモドーロタイマーを作成', () {
        // arrange & act
        final timer = Timer.pomodoro(id: 'test-id', taskId: 'task-1');

        // assert
        expect(timer.id, 'test-id');
        expect(timer.type, TimerType.pomodoro);
        expect(timer.durationMinutes, 25);
        expect(timer.remainingSeconds, 25 * 60);
        expect(timer.state, TimerState.idle);
        expect(timer.taskId, 'task-1');
      });

      test('shortBreak - 短い休憩タイマーを作成', () {
        // arrange & act
        final timer = Timer.shortBreak(id: 'test-id');

        // assert
        expect(timer.type, TimerType.shortBreak);
        expect(timer.durationMinutes, 5);
        expect(timer.remainingSeconds, 5 * 60);
      });

      test('longBreak - 長い休憩タイマーを作成', () {
        // arrange & act
        final timer = Timer.longBreak(id: 'test-id');

        // assert
        expect(timer.type, TimerType.longBreak);
        expect(timer.durationMinutes, 15);
        expect(timer.remainingSeconds, 15 * 60);
      });

      test('custom - カスタムタイマーを作成', () {
        // arrange & act
        final timer = Timer.custom(
          id: 'test-id',
          durationMinutes: 30,
          taskId: 'task-1',
        );

        // assert
        expect(timer.type, TimerType.custom);
        expect(timer.durationMinutes, 30);
        expect(timer.remainingSeconds, 30 * 60);
        expect(timer.taskId, 'task-1');
      });
    });

    group('copyWith', () {
      test('状態を変更したコピーを作成', () {
        // arrange
        final original = Timer.pomodoro(id: 'test-id');

        // act
        final modified = original.copyWith(
          state: TimerState.running,
          remainingSeconds: 1000,
        );

        // assert
        expect(modified.id, original.id);
        expect(modified.state, TimerState.running);
        expect(modified.remainingSeconds, 1000);
        expect(modified.durationMinutes, original.durationMinutes);
      });
    });

    group('toJson / fromJson', () {
      test('JSONへシリアライズ・デシリアライズができる', () {
        // arrange
        final original = Timer.pomodoro(
          id: 'test-id',
          taskId: 'task-1',
          pomodoroCount: 3,
        ).copyWith(
          state: TimerState.running,
          startedAt: DateTime(2025, 1, 1, 10, 0),
        );

        // act
        final json = original.toJson();
        final deserialized = Timer.fromJson(json);

        // assert
        expect(deserialized.id, original.id);
        expect(deserialized.type, original.type);
        expect(deserialized.state, original.state);
        expect(deserialized.durationMinutes, original.durationMinutes);
        expect(deserialized.remainingSeconds, original.remainingSeconds);
        expect(deserialized.taskId, original.taskId);
        expect(deserialized.pomodoroCount, original.pomodoroCount);
        expect(
          deserialized.startedAt?.millisecondsSinceEpoch,
          original.startedAt?.millisecondsSinceEpoch,
        );
      });
    });

    group('progress計算', () {
      test('進捗率が正しく計算される', () {
        // arrange
        final timer = Timer.pomodoro(id: 'test-id').copyWith(
          remainingSeconds: 750, // 25分の半分
        );

        // act
        final progress = timer.progress;

        // assert
        expect(progress, 0.5);
      });

      test('残り時間0のときは進捗率1.0', () {
        // arrange
        final timer = Timer.pomodoro(id: 'test-id').copyWith(
          remainingSeconds: 0,
        );

        // act
        final progress = timer.progress;

        // assert
        expect(progress, 1.0);
      });
    });

    group('状態判定', () {
      test('isRunning - 実行中かどうか', () {
        final idleTimer = Timer.pomodoro(id: 'test-id');
        final runningTimer = idleTimer.copyWith(state: TimerState.running);

        expect(idleTimer.isRunning, false);
        expect(runningTimer.isRunning, true);
      });

      test('isPaused - 一時停止中かどうか', () {
        final runningTimer = Timer.pomodoro(id: 'test-id')
            .copyWith(state: TimerState.running);
        final pausedTimer = runningTimer.copyWith(state: TimerState.paused);

        expect(runningTimer.isPaused, false);
        expect(pausedTimer.isPaused, true);
      });

      test('isCompleted - 完了したかどうか', () {
        final runningTimer = Timer.pomodoro(id: 'test-id')
            .copyWith(state: TimerState.running);
        final completedTimer = runningTimer.copyWith(
          state: TimerState.completed,
        );

        expect(runningTimer.isCompleted, false);
        expect(completedTimer.isCompleted, true);
      });
    });

    group('formattedTime', () {
      test('残り時間を「分:秒」形式で取得', () {
        final timer1 = Timer.pomodoro(id: 'test-id')
            .copyWith(remainingSeconds: 125);
        final timer2 = Timer.pomodoro(id: 'test-id')
            .copyWith(remainingSeconds: 59);
        final timer3 = Timer.pomodoro(id: 'test-id')
            .copyWith(remainingSeconds: 3661); // 61分1秒

        expect(timer1.formattedTime, '02:05');
        expect(timer2.formattedTime, '00:59');
        expect(timer3.formattedTime, '61:01');
      });
    });

    group('nextTimerType', () {
      test('ポモドーロ後は短い休憩', () {
        final timer = Timer.pomodoro(id: 'test-id', pomodoroCount: 0);
        expect(timer.nextTimerType, TimerType.shortBreak);
      });

      test('4回目のポモドーロ後は長い休憩', () {
        final timer = Timer.pomodoro(id: 'test-id', pomodoroCount: 3);
        expect(timer.nextTimerType, TimerType.longBreak);
      });

      test('休憩後はポモドーロ', () {
        final shortBreakTimer = Timer.shortBreak(
          id: 'test-id',
          pomodoroCount: 1,
        );
        final longBreakTimer = Timer.longBreak(
          id: 'test-id',
          pomodoroCount: 4,
        );

        expect(shortBreakTimer.nextTimerType, TimerType.pomodoro);
        expect(longBreakTimer.nextTimerType, TimerType.pomodoro);
      });

      test('カスタムタイマーは次もカスタム', () {
        final timer = Timer.custom(id: 'test-id', durationMinutes: 30);
        expect(timer.nextTimerType, TimerType.custom);
      });
    });
  });
}
