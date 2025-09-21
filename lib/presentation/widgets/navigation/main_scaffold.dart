import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_aiagent/domain/entities/navigation/tab_item.dart';
import 'package:task_aiagent/presentation/providers/navigation/navigation_provider.dart';
import 'package:task_aiagent/presentation/widgets/navigation/bottom_navigation_bar_widget.dart';
import 'package:task_aiagent/presentation/providers/calendar_provider.dart';
import 'package:task_aiagent/presentation/providers/task_providers.dart';
import 'package:task_aiagent/presentation/widgets/task/task_form_dialog.dart';

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
    if(location.startsWith('/task')) return 1;
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
          ref.read(navigationProvider.notifier).switchTabByIndex(index);
          context.go(TabItem.tabs[index].route);
        }
      ),
      floatingActionButton: _buildFloatingActionButton(context, ref, selectedIndex),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context, WidgetRef ref, int selectedIndex) {
    if (selectedIndex == 3) { // Timer tab
      return null;
    }

    return FloatingActionButton(
      onPressed: () => _showAddTaskDialog(context, ref, selectedIndex),
      child: const Icon(Icons.add),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref, int selectedIndex) {
    DateTime? initialDate;
    if (selectedIndex == 2) { // Calendar tab
      initialDate = ref.read(selectedDayProvider);
    }

    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        initialDueDate: initialDate,
        onSave: (task) {
          ref.read(taskListProvider.notifier).createTask(
            title: task.title,
            description: task.description,
            estimatedMinutes: task.estimatedMinutes,
            priority: task.priority,
            dueDate: task.dueDate,
          );
        },
      ),
    );
  }
}
