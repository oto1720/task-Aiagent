// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedDay)
const selectedDayProvider = SelectedDayProvider._();

final class SelectedDayProvider
    extends $NotifierProvider<SelectedDay, DateTime> {
  const SelectedDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDayHash();

  @$internal
  @override
  SelectedDay create() => SelectedDay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$selectedDayHash() => r'78d02c1ad7f06ab41297b5152760a1d09d3eeb23';

abstract class _$SelectedDay extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(calendarEvents)
const calendarEventsProvider = CalendarEventsProvider._();

final class CalendarEventsProvider
    extends
        $FunctionalProvider<
          Map<DateTime, List<Task>>,
          Map<DateTime, List<Task>>,
          Map<DateTime, List<Task>>
        >
    with $Provider<Map<DateTime, List<Task>>> {
  const CalendarEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarEventsHash();

  @$internal
  @override
  $ProviderElement<Map<DateTime, List<Task>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<DateTime, List<Task>> create(Ref ref) {
    return calendarEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<DateTime, List<Task>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<DateTime, List<Task>>>(value),
    );
  }
}

String _$calendarEventsHash() => r'e1162cece9fd1013f05b49ca3dbfbad0471ce873';

@ProviderFor(tasksForDay)
const tasksForDayProvider = TasksForDayFamily._();

final class TasksForDayProvider
    extends $FunctionalProvider<List<Task>, List<Task>, List<Task>>
    with $Provider<List<Task>> {
  const TasksForDayProvider._({
    required TasksForDayFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'tasksForDayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tasksForDayHash();

  @override
  String toString() {
    return r'tasksForDayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Task> create(Ref ref) {
    final argument = this.argument as DateTime;
    return tasksForDay(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Task> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Task>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TasksForDayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tasksForDayHash() => r'81306449418860a86f85309009efd452575628e2';

final class TasksForDayFamily extends $Family
    with $FunctionalFamilyOverride<List<Task>, DateTime> {
  const TasksForDayFamily._()
    : super(
        retry: null,
        name: r'tasksForDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TasksForDayProvider call(DateTime day) =>
      TasksForDayProvider._(argument: day, from: this);

  @override
  String toString() => r'tasksForDayProvider';
}

@ProviderFor(todaySchedule)
const todayScheduleProvider = TodayScheduleProvider._();

final class TodayScheduleProvider
    extends $FunctionalProvider<DailySchedule?, DailySchedule?, DailySchedule?>
    with $Provider<DailySchedule?> {
  const TodayScheduleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayScheduleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayScheduleHash();

  @$internal
  @override
  $ProviderElement<DailySchedule?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DailySchedule? create(Ref ref) {
    return todaySchedule(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailySchedule? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailySchedule?>(value),
    );
  }
}

String _$todayScheduleHash() => r'5dd35b816cfbecd38cd5b1cb191f45f206b56f26';

@ProviderFor(CombinedTodaySchedule)
const combinedTodayScheduleProvider = CombinedTodayScheduleProvider._();

final class CombinedTodayScheduleProvider
    extends $NotifierProvider<CombinedTodaySchedule, List<dynamic>> {
  const CombinedTodayScheduleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'combinedTodayScheduleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$combinedTodayScheduleHash();

  @$internal
  @override
  CombinedTodaySchedule create() => CombinedTodaySchedule();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<dynamic>>(value),
    );
  }
}

String _$combinedTodayScheduleHash() =>
    r'68a470c340693009abec8f1e355362a8b6b5143d';

abstract class _$CombinedTodaySchedule extends $Notifier<List<dynamic>> {
  List<dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<dynamic>, List<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<dynamic>, List<dynamic>>,
              List<dynamic>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
