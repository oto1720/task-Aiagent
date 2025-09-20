import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_aiagent/domain/entities/navigation/navigation_state.dart';
import 'package:task_aiagent/domain/usecases/navigation/navigation_usecase.dart';
import 'package:task_aiagent/domain/entities/navigation/tab_item.dart';

part 'navigation_provider.g.dart';

@riverpod
class NavigationNotifier extends _$NavigationNotifier {
  late final NavigationUseCase _navigationUseCase;

  @override
  NavigationState build() {
    _navigationUseCase = NavigationUseCase();
    return const NavigationState(currentTab: TabType.home, currentIndex: 0);
  }

void switchTab(TabType tabType){
  state = _navigationUseCase.switchTab(state, tabType);
}
void switchTabByIndex(int index){
  state = _navigationUseCase.switchTabByIndex(state, index);
}
String getTabRoute(TabType tabType){
  return _navigationUseCase.getRouteForTab(state.currentTab);
}
  
  NavigationUseCase navigationUseCase( ref) {
    return NavigationUseCase();
  }
}