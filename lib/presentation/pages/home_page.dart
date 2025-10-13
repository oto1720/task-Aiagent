import 'package:flutter/material.dart';
import 'package:task_aiagent/presentation/features/home/home_feature.dart';

/// ホームページ
///
/// feature-basedアーキテクチャを採用し、HomeFeatureに実装を委譲
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeFeature();
  }
}
