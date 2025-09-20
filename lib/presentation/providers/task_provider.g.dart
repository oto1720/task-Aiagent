// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskListNotifier)
const taskListProvider = TaskListNotifierProvider._();

final class TaskListNotifierProvider
    extends $NotifierProvider<TaskListNotifier, List<Task>> {
  const TaskListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskListNotifierHash();

  @$internal
  @override
  TaskListNotifier create() => TaskListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Task> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Task>>(value),
    );
  }
}

String _$taskListNotifierHash() => r'168044667d77c894fdde8630378617b99fada303';

abstract class _$TaskListNotifier extends $Notifier<List<Task>> {
  List<Task> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Task>, List<Task>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Task>, List<Task>>,
              List<Task>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ScheduleNotifier)
const scheduleProvider = ScheduleNotifierProvider._();

final class ScheduleNotifierProvider
    extends $NotifierProvider<ScheduleNotifier, DailySchedule?> {
  const ScheduleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleNotifierHash();

  @$internal
  @override
  ScheduleNotifier create() => ScheduleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailySchedule? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailySchedule?>(value),
    );
  }
}

String _$scheduleNotifierHash() => r'30e3e3b9757456fac2966faf66a1deb8801660f8';

abstract class _$ScheduleNotifier extends $Notifier<DailySchedule?> {
  DailySchedule? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DailySchedule?, DailySchedule?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DailySchedule?, DailySchedule?>,
              DailySchedule?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
