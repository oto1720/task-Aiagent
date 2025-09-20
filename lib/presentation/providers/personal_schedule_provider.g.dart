// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_schedule_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(personalScheduleRepository)
const personalScheduleRepositoryProvider =
    PersonalScheduleRepositoryProvider._();

final class PersonalScheduleRepositoryProvider
    extends
        $FunctionalProvider<
          PersonalScheduleRepository,
          PersonalScheduleRepository,
          PersonalScheduleRepository
        >
    with $Provider<PersonalScheduleRepository> {
  const PersonalScheduleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personalScheduleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personalScheduleRepositoryHash();

  @$internal
  @override
  $ProviderElement<PersonalScheduleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PersonalScheduleRepository create(Ref ref) {
    return personalScheduleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PersonalScheduleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PersonalScheduleRepository>(value),
    );
  }
}

String _$personalScheduleRepositoryHash() =>
    r'641f62b475a49a2d8afb32cae2c1f904f122c25a';

@ProviderFor(PersonalScheduleList)
const personalScheduleListProvider = PersonalScheduleListProvider._();

final class PersonalScheduleListProvider
    extends $NotifierProvider<PersonalScheduleList, List<PersonalSchedule>> {
  const PersonalScheduleListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personalScheduleListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personalScheduleListHash();

  @$internal
  @override
  PersonalScheduleList create() => PersonalScheduleList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PersonalSchedule> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PersonalSchedule>>(value),
    );
  }
}

String _$personalScheduleListHash() =>
    r'4b08a96cefc7466051c9953ed2bc0f186af2e03d';

abstract class _$PersonalScheduleList
    extends $Notifier<List<PersonalSchedule>> {
  List<PersonalSchedule> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<PersonalSchedule>, List<PersonalSchedule>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<PersonalSchedule>, List<PersonalSchedule>>,
              List<PersonalSchedule>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(personalScheduleEvents)
const personalScheduleEventsProvider = PersonalScheduleEventsProvider._();

final class PersonalScheduleEventsProvider
    extends
        $FunctionalProvider<
          Map<DateTime, List<PersonalSchedule>>,
          Map<DateTime, List<PersonalSchedule>>,
          Map<DateTime, List<PersonalSchedule>>
        >
    with $Provider<Map<DateTime, List<PersonalSchedule>>> {
  const PersonalScheduleEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personalScheduleEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personalScheduleEventsHash();

  @$internal
  @override
  $ProviderElement<Map<DateTime, List<PersonalSchedule>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<DateTime, List<PersonalSchedule>> create(Ref ref) {
    return personalScheduleEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<DateTime, List<PersonalSchedule>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Map<DateTime, List<PersonalSchedule>>>(value),
    );
  }
}

String _$personalScheduleEventsHash() =>
    r'ab3d20a19bb2fe74b9f7a630a4598b24d65e9f03';

@ProviderFor(personalSchedulesForDay)
const personalSchedulesForDayProvider = PersonalSchedulesForDayFamily._();

final class PersonalSchedulesForDayProvider
    extends
        $FunctionalProvider<
          List<PersonalSchedule>,
          List<PersonalSchedule>,
          List<PersonalSchedule>
        >
    with $Provider<List<PersonalSchedule>> {
  const PersonalSchedulesForDayProvider._({
    required PersonalSchedulesForDayFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'personalSchedulesForDayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personalSchedulesForDayHash();

  @override
  String toString() {
    return r'personalSchedulesForDayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<PersonalSchedule>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<PersonalSchedule> create(Ref ref) {
    final argument = this.argument as DateTime;
    return personalSchedulesForDay(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PersonalSchedule> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PersonalSchedule>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PersonalSchedulesForDayProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personalSchedulesForDayHash() =>
    r'f9ff3accfd3509130f01eb43e6ef32fa63a9b453';

final class PersonalSchedulesForDayFamily extends $Family
    with $FunctionalFamilyOverride<List<PersonalSchedule>, DateTime> {
  const PersonalSchedulesForDayFamily._()
    : super(
        retry: null,
        name: r'personalSchedulesForDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PersonalSchedulesForDayProvider call(DateTime day) =>
      PersonalSchedulesForDayProvider._(argument: day, from: this);

  @override
  String toString() => r'personalSchedulesForDayProvider';
}

@ProviderFor(todayPersonalSchedules)
const todayPersonalSchedulesProvider = TodayPersonalSchedulesProvider._();

final class TodayPersonalSchedulesProvider
    extends
        $FunctionalProvider<
          List<PersonalSchedule>,
          List<PersonalSchedule>,
          List<PersonalSchedule>
        >
    with $Provider<List<PersonalSchedule>> {
  const TodayPersonalSchedulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayPersonalSchedulesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayPersonalSchedulesHash();

  @$internal
  @override
  $ProviderElement<List<PersonalSchedule>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<PersonalSchedule> create(Ref ref) {
    return todayPersonalSchedules(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PersonalSchedule> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PersonalSchedule>>(value),
    );
  }
}

String _$todayPersonalSchedulesHash() =>
    r'876c0cbfce476d680b6f53a4634ded008bdfd02a';
