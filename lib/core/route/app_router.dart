import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:task_aiagent/presentation/page/home.dart';
import 'package:task_aiagent/presentation/page/calendar.dart';


final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      
      routes: [
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
      ],
    ),
  ],
);
