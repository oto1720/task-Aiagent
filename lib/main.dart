import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/presentation/page/home.dart';

/// TimeFlowアプリのメインエントリーポイント
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// TimeFlowアプリケーションのルートウィジェット
class MyApp extends StatelessWidget {
  /// MyAppのコンストラクタ
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomeScreen(),
      );
}