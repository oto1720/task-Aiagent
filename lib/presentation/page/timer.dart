// lib/presentation/page/timer.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/domain/entities/timer.dart' as timer_entity;
import 'package:task_aiagent/presentation/providers/timer/timer_providers.dart';
import 'package:task_aiagent/presentation/widgets/timer/timer_display.dart';
import 'package:task_aiagent/presentation/widgets/timer/timer_controls.dart';
import 'package:task_aiagent/presentation/widgets/timer/timer_type_selector.dart';
import 'package:task_aiagent/presentation/widgets/timer/pomodoro_stats.dart';

/// Timer Page
class TimerPage extends ConsumerStatefulWidget {
  const TimerPage({super.key});

  @override
  ConsumerState<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage> {
  timer_entity.TimerType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final timerAsync = ref.watch(timerProvider);
    final pomodoroCountAsync = ref.watch(todayPomodoroCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Pomodoro Stats
              pomodoroCountAsync.when(
                data: (count) {
                  final timer = timerAsync.value;
                  return PomodoroStats(
                    todayCount: count,
                    currentCycle: timer?.pomodoroCount ?? 0,
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const PomodoroStats(todayCount: 0),
              ),
              const SizedBox(height: 32),

              // Timer Type Selector
              TimerTypeSelector(
                selectedType: _selectedType ?? timerAsync.value?.type,
                onTypeSelected: (type) async {
                  setState(() {
                    _selectedType = type;
                  });

                  if (type == timer_entity.TimerType.custom) {
                    await _showCustomDurationDialog(context);
                  } else {
                    await ref
                        .read(timerProvider.notifier)
                        .createTimer(type: type);
                  }
                },
              ),
              const SizedBox(height: 48),

              // Timer Display
              Expanded(
                child: timerAsync.when(
                  data: (timer) => TimerDisplay(timer: timer),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error: $error'),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Timer Controls
              timerAsync.when(
                data: (timer) => TimerControls(
                  timer: timer,
                  onStart: () async {
                    await ref.read(timerProvider.notifier).start();
                  },
                  onPause: () async {
                    await ref.read(timerProvider.notifier).pause();
                  },
                  onResume: () async {
                    await ref.read(timerProvider.notifier).resume();
                  },
                  onReset: () async {
                    await ref.read(timerProvider.notifier).reset();
                  },
                  onComplete: () async {
                    await ref.read(timerProvider.notifier).complete();
                    await _showCompletionDialog(context, timer);
                  },
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Custom Duration Dialog
  Future<void> _showCustomDurationDialog(BuildContext context) async {
    int selectedMinutes = 25;

    final result = await showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Custom Timer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$selectedMinutes min',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                value: selectedMinutes.toDouble(),
                min: 1,
                max: 60,
                divisions: 59,
                label: '$selectedMinutes min',
                onChanged: (value) {
                  setState(() {
                    selectedMinutes = value.toInt();
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(selectedMinutes),
              child: const Text('Set'),
            ),
          ],
        ),
      ),
    );

    if (result != null && mounted) {
      await ref.read(timerProvider.notifier).createTimer(
            type: timer_entity.TimerType.custom,
            durationMinutes: result,
          );
    }
  }

  /// Completion Dialog
  Future<void> _showCompletionDialog(
    BuildContext context,
    timer_entity.Timer? timer,
  ) async {
    if (timer == null) return;

    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Timer Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              timer.type == timer_entity.TimerType.pomodoro
                  ? 'Great work! Take a break?'
                  : 'Break is over! Start working?',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Next'),
          ),
        ],
      ),
    );

    if (shouldContinue == true && mounted) {
      await ref.read(timerProvider.notifier).nextTimer();
    }
  }
}
