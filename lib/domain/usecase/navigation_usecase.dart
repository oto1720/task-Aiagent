import 'package:task_aiagent/domain/entities/navigation/tab_item.dart';
import 'package:task_aiagent/domain/entities/navigation/navigation_state.dart';

class NavigationUseCase{
  NavigationState switchTab(NavigationState currentState, TabType newTab) {
    final tabItem = TabItem.tabs.indexWhere((tab) => tab.type == newTab);

    return currentState.copyWith(
      currentTab: newTab,
      currentIndex: tabItem,
    );
  }

  NavigationState switchTabByIndex(NavigationState currentState, int index){
    if(index < 0 || index >= TabItem.tabs.length){
      return currentState;
    }
    final tabType = TabItem.tabs[index].type;

    return currentState.copyWith(
      currentTab: tabType,
      currentIndex: index,
    );
  }

  bool canNavigateToTab(TabType tabType){
    return TabItem.tabs.any((tab) => tab.type == tabType);
  }
  String getRouteForTab(TabType tabType){
    final tab = TabItem.getByType(tabType);
    return tab.route;
  }
}