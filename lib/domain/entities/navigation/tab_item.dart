import 'package:flutter/material.dart';

enum TabType{
  home,
  task,
  calendar,
  timer,
}

class TabItem{
  final TabType type;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const TabItem({
    required this.type,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
  static const List<TabItem> tabs = [
  TabItem(type: TabType.home, label: 'Home', icon: Icons.home, activeIcon: Icons.home, route: '/home'),
  TabItem(type: TabType.task, label: 'Task', icon: Icons.task, activeIcon: Icons.task, route: '/task'),
  TabItem(type: TabType.calendar, label: 'Calendar', icon: Icons.calendar_today, activeIcon: Icons.calendar_today, route: '/calendar'),
  TabItem(type: TabType.timer, label: 'Timer', icon: Icons.timer, activeIcon: Icons.timer, route: '/timer'),
];

static TabItem getByType(TabType type){
  return tabs.firstWhere((tab) => tab.type == type);
}
}

