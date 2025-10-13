import 'package:flutter/material.dart';
import 'package:task_aiagent/presentation/features/calendar/calendar_feature.dart';

/// カレンダーページ
///
/// feature-basedアーキテクチャを採用し、CalendarFeatureに実装を委譲
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalendarFeature();
  }
}
