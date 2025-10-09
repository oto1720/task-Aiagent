import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
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
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage(
              child: Container(), // IndexedStackで管理されるため空のWidget
            );
          },
        ),
        GoRoute(
          path: '/task',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage(
              child: Container(),
            );
          },
        ),
        GoRoute(
          path: '/calendar',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage(
              child: Container(),
            );
          },
        ),
        GoRoute(
          path: '/timer',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return NoTransitionPage(
              child: Container(),
            );
          },
        ),
      ],
    ),
  ],
);
