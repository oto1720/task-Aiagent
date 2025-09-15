import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_aiagent/domain/entities/navigation/tab_item.dart';
import 'package:task_aiagent/presentation/providers/navigation/navigation_provider.dart';
import 'package:task_aiagent/presentation/widgets/navigation/bottom_navigation_bar_widget.dart';

class MainScaffold extends ConsumerWidget{
  final Widget child;
  final String location;

  const MainScaffold({
    Key? key,
    required this.child,
    required this.location,
  }) : super(key: key);

  int _calculateSelectedIndex(String location){
    if(location.startsWith('/home')) return 0;
    if(location.startsWith('/tasks')) return 1;
    if(location.startsWith('/calendar')) return 2;
    if(location.startsWith('/timer')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final selectedIndex = _calculateSelectedIndex(location);

    return Scaffold(
      body:child,
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: selectedIndex,
        onTap: (index){
          ref.read(navigationNotifierProvider.notifier).switchTabByIndex(index);
          context.go(TabItem.tabs[index].route);
        }
        )
      );
  }
}
