import 'package:flutter/material.dart';
import 'package:task_aiagent/domain/entities/navigation/tab_item.dart';

class BottomNavigationBarWidget extends StatelessWidget{
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      items: TabItem.tabs.map(((tab){
        final isSelected = TabItem.tabs.indexOf(tab) == currentIndex;
        return BottomNavigationBarItem(
          icon: Icon(isSelected ? tab.activeIcon: tab.icon),
          label: tab.label,
        );
      })).toList(),
    );
  }
  }
