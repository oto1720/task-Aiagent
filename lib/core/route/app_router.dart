import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:task_aiagent/presentation/page/home.dart';
import 'package:task_aiagent/presentation/page/calendar.dart';
import 'package:task_aiagent/presentation/widgets/navigation/main_scaffold.dart';


final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder:(context,state,child){
        return MainScaffold(
          location: state.uri.toString(),
          child: child,
          );
      },
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
