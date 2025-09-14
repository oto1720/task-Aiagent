import 'package:freezed_annotation/freezed_annotation.dart';
import 'tab_item.dart';

part 'navigation_state.freezed.dart';

@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState({
    @Default(TabType.home) TabType currentTab,
    @Default(0) int currentIndex,
  }) = _NavigationState;
}