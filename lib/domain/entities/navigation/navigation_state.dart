import 'package:flutter/foundation.dart';
import 'package:task_aiagent/domain/entities/navigation/tab_item.dart';

@immutable
class NavigationState {
  final TabType currentTab;
  final int currentIndex;

  const NavigationState({
    this.currentTab = TabType.home,
    this.currentIndex = 0,
  });

  NavigationState copyWith({
    TabType? currentTab,
    int? currentIndex,
  }) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
