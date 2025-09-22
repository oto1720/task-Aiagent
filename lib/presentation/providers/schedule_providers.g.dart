// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scheduleLocalDataSource)
const scheduleLocalDataSourceProvider = ScheduleLocalDataSourceProvider._();

final class ScheduleLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ScheduleLocalDataSource,
          ScheduleLocalDataSource,
          ScheduleLocalDataSource
        >
    with $Provider<ScheduleLocalDataSource> {
  const ScheduleLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ScheduleLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScheduleLocalDataSource create(Ref ref) {
    return scheduleLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleLocalDataSource>(value),
    );
  }
}

String _$scheduleLocalDataSourceHash() =>
    r'f93bb16a7a0c7d9382205d80a07fcd1aa71527d8';

@ProviderFor(generateOptimalScheduleUseCase)
const generateOptimalScheduleUseCaseProvider =
    GenerateOptimalScheduleUseCaseProvider._();

final class GenerateOptimalScheduleUseCaseProvider
    extends
        $FunctionalProvider<
          GenerateOptimalScheduleUseCase,
          GenerateOptimalScheduleUseCase,
          GenerateOptimalScheduleUseCase
        >
    with $Provider<GenerateOptimalScheduleUseCase> {
  const GenerateOptimalScheduleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generateOptimalScheduleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generateOptimalScheduleUseCaseHash();

  @$internal
  @override
  $ProviderElement<GenerateOptimalScheduleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GenerateOptimalScheduleUseCase create(Ref ref) {
    return generateOptimalScheduleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenerateOptimalScheduleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenerateOptimalScheduleUseCase>(
        value,
      ),
    );
  }
}

String _$generateOptimalScheduleUseCaseHash() =>
    r'0c94f85707753de25b3a144b63b21db99ecc5cda';

@ProviderFor(TodaySchedule)
const todayScheduleProvider = TodayScheduleProvider._();

final class TodayScheduleProvider
    extends $AsyncNotifierProvider<TodaySchedule, DailySchedule?> {
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
  TodaySchedule create() => TodaySchedule();
}

String _$todayScheduleHash() => r'beef958d8035104ad5cd87344ba07100587b452e';

abstract class _$TodaySchedule extends $AsyncNotifier<DailySchedule?> {
  FutureOr<DailySchedule?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<DailySchedule?>, DailySchedule?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DailySchedule?>, DailySchedule?>,
              AsyncValue<DailySchedule?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(totalWorkingMinutesToday)
const totalWorkingMinutesTodayProvider = TotalWorkingMinutesTodayProvider._();

final class TotalWorkingMinutesTodayProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const TotalWorkingMinutesTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalWorkingMinutesTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalWorkingMinutesTodayHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return totalWorkingMinutesToday(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$totalWorkingMinutesTodayHash() =>
    r'576a896fd3001dd8db1a17b7f5fd221d7edfc18b';

@ProviderFor(remainingTasksCount)
const remainingTasksCountProvider = RemainingTasksCountProvider._();

final class RemainingTasksCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const RemainingTasksCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remainingTasksCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remainingTasksCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return remainingTasksCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$remainingTasksCountHash() =>
    r'abc999beeef34de4d871224ac86a46f14b319370';

@ProviderFor(currentScheduleItems)
const currentScheduleItemsProvider = CurrentScheduleItemsProvider._();

final class CurrentScheduleItemsProvider
    extends
        $FunctionalProvider<
          List<ScheduleItem>,
          List<ScheduleItem>,
          List<ScheduleItem>
        >
    with $Provider<List<ScheduleItem>> {
  const CurrentScheduleItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentScheduleItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentScheduleItemsHash();

  @$internal
  @override
  $ProviderElement<List<ScheduleItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ScheduleItem> create(Ref ref) {
    return currentScheduleItems(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ScheduleItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ScheduleItem>>(value),
    );
  }
}

String _$currentScheduleItemsHash() =>
    r'fd5eea11b50582206a4551a5c46c31fbaf05c35f';

@ProviderFor(currentScheduleItem)
const currentScheduleItemProvider = CurrentScheduleItemProvider._();

final class CurrentScheduleItemProvider
    extends $FunctionalProvider<ScheduleItem?, ScheduleItem?, ScheduleItem?>
    with $Provider<ScheduleItem?> {
  const CurrentScheduleItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentScheduleItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentScheduleItemHash();

  @$internal
  @override
  $ProviderElement<ScheduleItem?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScheduleItem? create(Ref ref) {
    return currentScheduleItem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleItem? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleItem?>(value),
    );
  }
}

String _$currentScheduleItemHash() =>
    r'd8135fea8f9072e7dacc48870e3d93016f77d669';

@ProviderFor(nextScheduleItem)
const nextScheduleItemProvider = NextScheduleItemProvider._();

final class NextScheduleItemProvider
    extends $FunctionalProvider<ScheduleItem?, ScheduleItem?, ScheduleItem?>
    with $Provider<ScheduleItem?> {
  const NextScheduleItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextScheduleItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextScheduleItemHash();

  @$internal
  @override
  $ProviderElement<ScheduleItem?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScheduleItem? create(Ref ref) {
    return nextScheduleItem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleItem? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleItem?>(value),
    );
  }
}

String _$nextScheduleItemHash() => r'395738d38f8fc6153ccbdc5c550436065b88179f';
