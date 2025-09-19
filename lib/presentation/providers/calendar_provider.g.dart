// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$calendarEventsHash() => r'ef13c88f8f465e9270540a61f393f0d72ce424fc';

/// See also [calendarEvents].
@ProviderFor(calendarEvents)
final calendarEventsProvider =
    AutoDisposeProvider<Map<DateTime, List<Task>>>.internal(
  calendarEvents,
  name: r'calendarEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calendarEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CalendarEventsRef = AutoDisposeProviderRef<Map<DateTime, List<Task>>>;
String _$tasksForDayHash() => r'3e7753ca37047a104ae5328d9abda6f93af05038';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [tasksForDay].
@ProviderFor(tasksForDay)
const tasksForDayProvider = TasksForDayFamily();

/// See also [tasksForDay].
class TasksForDayFamily extends Family<List<Task>> {
  /// See also [tasksForDay].
  const TasksForDayFamily();

  /// See also [tasksForDay].
  TasksForDayProvider call(
    DateTime day,
  ) {
    return TasksForDayProvider(
      day,
    );
  }

  @override
  TasksForDayProvider getProviderOverride(
    covariant TasksForDayProvider provider,
  ) {
    return call(
      provider.day,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tasksForDayProvider';
}

/// See also [tasksForDay].
class TasksForDayProvider extends AutoDisposeProvider<List<Task>> {
  /// See also [tasksForDay].
  TasksForDayProvider(
    DateTime day,
  ) : this._internal(
          (ref) => tasksForDay(
            ref as TasksForDayRef,
            day,
          ),
          from: tasksForDayProvider,
          name: r'tasksForDayProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tasksForDayHash,
          dependencies: TasksForDayFamily._dependencies,
          allTransitiveDependencies:
              TasksForDayFamily._allTransitiveDependencies,
          day: day,
        );

  TasksForDayProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.day,
  }) : super.internal();

  final DateTime day;

  @override
  Override overrideWith(
    List<Task> Function(TasksForDayRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksForDayProvider._internal(
        (ref) => create(ref as TasksForDayRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        day: day,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Task>> createElement() {
    return _TasksForDayProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksForDayProvider && other.day == day;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, day.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TasksForDayRef on AutoDisposeProviderRef<List<Task>> {
  /// The parameter `day` of this provider.
  DateTime get day;
}

class _TasksForDayProviderElement extends AutoDisposeProviderElement<List<Task>>
    with TasksForDayRef {
  _TasksForDayProviderElement(super.provider);

  @override
  DateTime get day => (origin as TasksForDayProvider).day;
}

String _$selectedDayHash() => r'78d02c1ad7f06ab41297b5152760a1d09d3eeb23';

/// See also [SelectedDay].
@ProviderFor(SelectedDay)
final selectedDayProvider =
    AutoDisposeNotifierProvider<SelectedDay, DateTime>.internal(
  SelectedDay.new,
  name: r'selectedDayProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedDayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDay = AutoDisposeNotifier<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
