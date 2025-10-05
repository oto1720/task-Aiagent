// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(timerLocalDataSource)
const timerLocalDataSourceProvider = TimerLocalDataSourceProvider._();

final class TimerLocalDataSourceProvider
    extends
        $FunctionalProvider<
          TimerLocalDataSource,
          TimerLocalDataSource,
          TimerLocalDataSource
        >
    with $Provider<TimerLocalDataSource> {
  const TimerLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<TimerLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TimerLocalDataSource create(Ref ref) {
    return timerLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimerLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimerLocalDataSource>(value),
    );
  }
}

String _$timerLocalDataSourceHash() =>
    r'fa7912557a1a0b7dd3c2a6eb9bc585ab8cab7bf0';

@ProviderFor(timerRepository)
const timerRepositoryProvider = TimerRepositoryProvider._();

final class TimerRepositoryProvider
    extends
        $FunctionalProvider<TimerRepository, TimerRepository, TimerRepository>
    with $Provider<TimerRepository> {
  const TimerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerRepositoryHash();

  @$internal
  @override
  $ProviderElement<TimerRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TimerRepository create(Ref ref) {
    return timerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimerRepository>(value),
    );
  }
}

String _$timerRepositoryHash() => r'9bff62ed573c80c774c46f13ba005160921b69df';

@ProviderFor(startTimerUseCase)
const startTimerUseCaseProvider = StartTimerUseCaseProvider._();

final class StartTimerUseCaseProvider
    extends
        $FunctionalProvider<
          StartTimerUseCase,
          StartTimerUseCase,
          StartTimerUseCase
        >
    with $Provider<StartTimerUseCase> {
  const StartTimerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startTimerUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startTimerUseCaseHash();

  @$internal
  @override
  $ProviderElement<StartTimerUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StartTimerUseCase create(Ref ref) {
    return startTimerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StartTimerUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StartTimerUseCase>(value),
    );
  }
}

String _$startTimerUseCaseHash() => r'bda6fc2a5b57efe908da26aa3096864f69c0701a';

@ProviderFor(pauseTimerUseCase)
const pauseTimerUseCaseProvider = PauseTimerUseCaseProvider._();

final class PauseTimerUseCaseProvider
    extends
        $FunctionalProvider<
          PauseTimerUseCase,
          PauseTimerUseCase,
          PauseTimerUseCase
        >
    with $Provider<PauseTimerUseCase> {
  const PauseTimerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pauseTimerUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pauseTimerUseCaseHash();

  @$internal
  @override
  $ProviderElement<PauseTimerUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PauseTimerUseCase create(Ref ref) {
    return pauseTimerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PauseTimerUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PauseTimerUseCase>(value),
    );
  }
}

String _$pauseTimerUseCaseHash() => r'972517649f29238c0d489e6ff7510813adf0d714';

@ProviderFor(resumeTimerUseCase)
const resumeTimerUseCaseProvider = ResumeTimerUseCaseProvider._();

final class ResumeTimerUseCaseProvider
    extends
        $FunctionalProvider<
          ResumeTimerUseCase,
          ResumeTimerUseCase,
          ResumeTimerUseCase
        >
    with $Provider<ResumeTimerUseCase> {
  const ResumeTimerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resumeTimerUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resumeTimerUseCaseHash();

  @$internal
  @override
  $ProviderElement<ResumeTimerUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResumeTimerUseCase create(Ref ref) {
    return resumeTimerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResumeTimerUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResumeTimerUseCase>(value),
    );
  }
}

String _$resumeTimerUseCaseHash() =>
    r'71c01165cf8ad99db7b4938c03d8282a80b592c9';

@ProviderFor(completeTimerUseCase)
const completeTimerUseCaseProvider = CompleteTimerUseCaseProvider._();

final class CompleteTimerUseCaseProvider
    extends
        $FunctionalProvider<
          CompleteTimerUseCase,
          CompleteTimerUseCase,
          CompleteTimerUseCase
        >
    with $Provider<CompleteTimerUseCase> {
  const CompleteTimerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeTimerUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeTimerUseCaseHash();

  @$internal
  @override
  $ProviderElement<CompleteTimerUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompleteTimerUseCase create(Ref ref) {
    return completeTimerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompleteTimerUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompleteTimerUseCase>(value),
    );
  }
}

String _$completeTimerUseCaseHash() =>
    r'74982784de201aadac8499fd80b4627f3e5740a6';

@ProviderFor(resetTimerUseCase)
const resetTimerUseCaseProvider = ResetTimerUseCaseProvider._();

final class ResetTimerUseCaseProvider
    extends
        $FunctionalProvider<
          ResetTimerUseCase,
          ResetTimerUseCase,
          ResetTimerUseCase
        >
    with $Provider<ResetTimerUseCase> {
  const ResetTimerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetTimerUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetTimerUseCaseHash();

  @$internal
  @override
  $ProviderElement<ResetTimerUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResetTimerUseCase create(Ref ref) {
    return resetTimerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResetTimerUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResetTimerUseCase>(value),
    );
  }
}

String _$resetTimerUseCaseHash() => r'bf7cc3faa0025b59eab9a7f171898776478ae5cd';

@ProviderFor(updateTimerUseCase)
const updateTimerUseCaseProvider = UpdateTimerUseCaseProvider._();

final class UpdateTimerUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateTimerUseCase,
          UpdateTimerUseCase,
          UpdateTimerUseCase
        >
    with $Provider<UpdateTimerUseCase> {
  const UpdateTimerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateTimerUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateTimerUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateTimerUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateTimerUseCase create(Ref ref) {
    return updateTimerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateTimerUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateTimerUseCase>(value),
    );
  }
}

String _$updateTimerUseCaseHash() =>
    r'5ba32fc02c834061de300777e8ec5df3df7d8c2c';

@ProviderFor(todayPomodoroCount)
const todayPomodoroCountProvider = TodayPomodoroCountProvider._();

final class TodayPomodoroCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const TodayPomodoroCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayPomodoroCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayPomodoroCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return todayPomodoroCount(ref);
  }
}

String _$todayPomodoroCountHash() =>
    r'4425cde761588ff5afbff93c87e20207d87d658b';

/// タイマー状態管理プロバイダー

@ProviderFor(TimerNotifier)
const timerProvider = TimerNotifierProvider._();

/// タイマー状態管理プロバイダー
final class TimerNotifierProvider
    extends $AsyncNotifierProvider<TimerNotifier, Timer?> {
  /// タイマー状態管理プロバイダー
  const TimerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerNotifierHash();

  @$internal
  @override
  TimerNotifier create() => TimerNotifier();
}

String _$timerNotifierHash() => r'a4187297b9624ebe8916199bd261fae9799ca5f7';

/// タイマー状態管理プロバイダー

abstract class _$TimerNotifier extends $AsyncNotifier<Timer?> {
  FutureOr<Timer?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Timer?>, Timer?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Timer?>, Timer?>,
              AsyncValue<Timer?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
