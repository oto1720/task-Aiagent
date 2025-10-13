import 'package:flutter/material.dart';
import 'package:task_aiagent/presentation/features/timer/timer_feature.dart';

/// タイマーページ
///
/// feature-basedアーキテクチャを採用し、TimerFeatureに実装を委譲
class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer'), centerTitle: true),
      body: const TimerFeature(),
    );
  }
}
