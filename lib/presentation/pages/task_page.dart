import 'package:flutter/material.dart';
import 'package:task_aiagent/presentation/features/task/task_feature.dart';

/// タスクページ
///
/// feature-basedアーキテクチャを採用し、TaskFeatureに実装を委譲
class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TaskFeature();
  }
}
