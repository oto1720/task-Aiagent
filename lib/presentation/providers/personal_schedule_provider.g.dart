// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_schedule_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$personalScheduleRepositoryHash() =>
    r'e8c10c712d09d4a56c8cdb0254c9c9aac07cbb08';

/// See also [personalScheduleRepository].
@ProviderFor(personalScheduleRepository)
final personalScheduleRepositoryProvider =
    AutoDisposeProvider<PersonalScheduleRepository>.internal(
  personalScheduleRepository,
  name: r'personalScheduleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$personalScheduleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PersonalScheduleRepositoryRef
    = AutoDisposeProviderRef<PersonalScheduleRepository>;
String _$personalScheduleEventsHash() =>
    r'431c3c6191cac946b81d04989eeac764053aa2ec';

/// See also [personalScheduleEvents].
@ProviderFor(personalScheduleEvents)
final personalScheduleEventsProvider =
    AutoDisposeProvider<Map<DateTime, List<PersonalSchedule>>>.internal(
  personalScheduleEvents,
  name: r'personalScheduleEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$personalScheduleEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PersonalScheduleEventsRef
    = AutoDisposeProviderRef<Map<DateTime, List<PersonalSchedule>>>;
String _$personalSchedulesForDayHash() =>
    r'cc3167bfd18766d1bfee9163c117b3d6bce483b0';

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

/// See also [personalSchedulesForDay].
@ProviderFor(personalSchedulesForDay)
const personalSchedulesForDayProvider = PersonalSchedulesForDayFamily();

/// See also [personalSchedulesForDay].
class PersonalSchedulesForDayFamily extends Family<List<PersonalSchedule>> {
  /// See also [personalSchedulesForDay].
  const PersonalSchedulesForDayFamily();

  /// See also [personalSchedulesForDay].
  PersonalSchedulesForDayProvider call(
    DateTime day,
  ) {
    return PersonalSchedulesForDayProvider(
      day,
    );
  }

  @override
  PersonalSchedulesForDayProvider getProviderOverride(
    covariant PersonalSchedulesForDayProvider provider,
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
  String? get name => r'personalSchedulesForDayProvider';
}

/// See also [personalSchedulesForDay].
class PersonalSchedulesForDayProvider
    extends AutoDisposeProvider<List<PersonalSchedule>> {
  /// See also [personalSchedulesForDay].
  PersonalSchedulesForDayProvider(
    DateTime day,
  ) : this._internal(
          (ref) => personalSchedulesForDay(
            ref as PersonalSchedulesForDayRef,
            day,
          ),
          from: personalSchedulesForDayProvider,
          name: r'personalSchedulesForDayProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$personalSchedulesForDayHash,
          dependencies: PersonalSchedulesForDayFamily._dependencies,
          allTransitiveDependencies:
              PersonalSchedulesForDayFamily._allTransitiveDependencies,
          day: day,
        );

  PersonalSchedulesForDayProvider._internal(
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
    List<PersonalSchedule> Function(PersonalSchedulesForDayRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PersonalSchedulesForDayProvider._internal(
        (ref) => create(ref as PersonalSchedulesForDayRef),
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
  AutoDisposeProviderElement<List<PersonalSchedule>> createElement() {
    return _PersonalSchedulesForDayProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonalSchedulesForDayProvider && other.day == day;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, day.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PersonalSchedulesForDayRef
    on AutoDisposeProviderRef<List<PersonalSchedule>> {
  /// The parameter `day` of this provider.
  DateTime get day;
}

class _PersonalSchedulesForDayProviderElement
    extends AutoDisposeProviderElement<List<PersonalSchedule>>
    with PersonalSchedulesForDayRef {
  _PersonalSchedulesForDayProviderElement(super.provider);

  @override
  DateTime get day => (origin as PersonalSchedulesForDayProvider).day;
}

String _$todayPersonalSchedulesHash() =>
    r'6063784680519dfe2c9f4d970c7cde7738004979';

/// See also [todayPersonalSchedules].
@ProviderFor(todayPersonalSchedules)
final todayPersonalSchedulesProvider =
    AutoDisposeProvider<List<PersonalSchedule>>.internal(
  todayPersonalSchedules,
  name: r'todayPersonalSchedulesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayPersonalSchedulesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TodayPersonalSchedulesRef
    = AutoDisposeProviderRef<List<PersonalSchedule>>;
String _$personalScheduleListHash() =>
    r'4b08a96cefc7466051c9953ed2bc0f186af2e03d';

/// See also [PersonalScheduleList].
@ProviderFor(PersonalScheduleList)
final personalScheduleListProvider = AutoDisposeNotifierProvider<
    PersonalScheduleList, List<PersonalSchedule>>.internal(
  PersonalScheduleList.new,
  name: r'personalScheduleListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$personalScheduleListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PersonalScheduleList = AutoDisposeNotifier<List<PersonalSchedule>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
