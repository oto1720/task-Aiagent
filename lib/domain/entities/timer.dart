// lib/domain/entities/timer.dart

/// タイマーの状態を表すEnum
enum TimerState {
  idle,       // 待機中
  running,    // 実行中
  paused,     // 一時停止中
  completed,  // 完了
}

/// タイマーのタイプを表すEnum
enum TimerType {
  pomodoro,   // ポモドーロタイマー（作業時間）
  shortBreak, // 短い休憩
  longBreak,  // 長い休憩
  custom,     // カスタムタイマー
}

/// タイマーエンティティ
///
/// タイマーの状態と設定を管理するエンティティ
/// ポモドーロテクニックに基づいたタイマー機能を提供
class Timer {
  final String id;                    // 一意識別子
  final TimerType type;               // タイマータイプ
  final TimerState state;             // 現在の状態
  final int durationMinutes;          // タイマー時間（分）
  final int remainingSeconds;         // 残り時間（秒）
  final DateTime? startedAt;          // 開始日時
  final DateTime? pausedAt;           // 一時停止日時
  final DateTime? completedAt;        // 完了日時
  final String? taskId;               // 関連するタスクID
  final int pomodoroCount;            // ポモドーロサイクル数

  const Timer({
    required this.id,
    required this.type,
    this.state = TimerState.idle,
    required this.durationMinutes,
    int? remainingSeconds,
    this.startedAt,
    this.pausedAt,
    this.completedAt,
    this.taskId,
    this.pomodoroCount = 0,
  }) : remainingSeconds = remainingSeconds ?? (durationMinutes * 60);

  /// デフォルトのポモドーロタイマーを作成
  factory Timer.pomodoro({
    required String id,
    String? taskId,
    int pomodoroCount = 0,
  }) {
    return Timer(
      id: id,
      type: TimerType.pomodoro,
      durationMinutes: 25,
      taskId: taskId,
      pomodoroCount: pomodoroCount,
    );
  }

  /// 短い休憩タイマーを作成
  factory Timer.shortBreak({
    required String id,
    int pomodoroCount = 0,
  }) {
    return Timer(
      id: id,
      type: TimerType.shortBreak,
      durationMinutes: 5,
      pomodoroCount: pomodoroCount,
    );
  }

  /// 長い休憩タイマーを作成
  factory Timer.longBreak({
    required String id,
    int pomodoroCount = 0,
  }) {
    return Timer(
      id: id,
      type: TimerType.longBreak,
      durationMinutes: 15,
      pomodoroCount: pomodoroCount,
    );
  }

  /// カスタムタイマーを作成
  factory Timer.custom({
    required String id,
    required int durationMinutes,
    String? taskId,
  }) {
    return Timer(
      id: id,
      type: TimerType.custom,
      durationMinutes: durationMinutes,
      taskId: taskId,
    );
  }

  Timer copyWith({
    String? id,
    TimerType? type,
    TimerState? state,
    int? durationMinutes,
    int? remainingSeconds,
    DateTime? startedAt,
    DateTime? pausedAt,
    DateTime? completedAt,
    String? taskId,
    int? pomodoroCount,
  }) {
    return Timer(
      id: id ?? this.id,
      type: type ?? this.type,
      state: state ?? this.state,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      startedAt: startedAt ?? this.startedAt,
      pausedAt: pausedAt ?? this.pausedAt,
      completedAt: completedAt ?? this.completedAt,
      taskId: taskId ?? this.taskId,
      pomodoroCount: pomodoroCount ?? this.pomodoroCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'state': state.index,
      'durationMinutes': durationMinutes,
      'remainingSeconds': remainingSeconds,
      'startedAt': startedAt?.millisecondsSinceEpoch,
      'pausedAt': pausedAt?.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'taskId': taskId,
      'pomodoroCount': pomodoroCount,
    };
  }

  factory Timer.fromJson(Map<String, dynamic> json) {
    return Timer(
      id: json['id'],
      type: TimerType.values[json['type']],
      state: TimerState.values[json['state']],
      durationMinutes: json['durationMinutes'],
      remainingSeconds: json['remainingSeconds'],
      startedAt: json['startedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['startedAt'])
          : null,
      pausedAt: json['pausedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['pausedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['completedAt'])
          : null,
      taskId: json['taskId'],
      pomodoroCount: json['pomodoroCount'] ?? 0,
    );
  }

  /// タイマーの進捗率を取得（0.0 ~ 1.0）
  double get progress {
    final totalSeconds = durationMinutes * 60;
    if (totalSeconds == 0) return 1.0;
    return 1.0 - (remainingSeconds / totalSeconds);
  }

  /// タイマーが実行中かどうか
  bool get isRunning => state == TimerState.running;

  /// タイマーが一時停止中かどうか
  bool get isPaused => state == TimerState.paused;

  /// タイマーが完了したかどうか
  bool get isCompleted => state == TimerState.completed;

  /// タイマーが待機中かどうか
  bool get isIdle => state == TimerState.idle;

  /// 残り時間を「分:秒」形式で取得
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 次のタイマータイプを取得（ポモドーロサイクルに基づく）
  TimerType get nextTimerType {
    if (type == TimerType.custom) return TimerType.custom;

    if (type == TimerType.pomodoro) {
      // 4ポモドーロごとに長い休憩
      return (pomodoroCount + 1) % 4 == 0
          ? TimerType.longBreak
          : TimerType.shortBreak;
    }

    return TimerType.pomodoro;
  }
}
