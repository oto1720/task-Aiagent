// lib/domain/entities/task.dart
import 'package:uuid/uuid.dart';
//優先度
enum TaskPriority {
    low,
    medium,
    high,
    urgent
  }

enum TaskStatus {
  upcoming,     // これから
  inProgress,   // 今日進行中
  completed     // 完了
}

class Task {
  // ── プロパティ定義 ──
  final String id;              // 一意識別子（UUID）
  final String title;           // タスク名
  final String description;     // タスク説明
  final TaskPriority priority;  // 優先度
  final TaskStatus status;      // 現在のステータス
  final int estimatedMinutes;   // 推定所要時間（分）
  final DateTime createdAt;     // 作成日時
  final DateTime? updatedAt;    // 更新日時
  final DateTime? scheduledAt;  // スケジュール予定日時
  final DateTime? dueDate;      // 期日
  final int? sortOrder;         // ドラッグ&ドロップ用の並び順
  final bool isToday;          // 今日のタスクフラグ
  final String category;        // カテゴリ

  Task({
    String? id,
    required this.title,
    this.description = '',
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.upcoming,
    required this.estimatedMinutes,
    DateTime? createdAt,
    this.updatedAt,
    this.scheduledAt,
    this.dueDate,
    this.sortOrder,
    this.isToday = false,
    this.category = 'General',
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    int? estimatedMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? scheduledAt,
    DateTime? dueDate,
    int? sortOrder,
    bool? isToday,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      dueDate: dueDate ?? this.dueDate,
      sortOrder: sortOrder ?? this.sortOrder,
      isToday: isToday ?? this.isToday,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'status': status.index,
      'estimatedMinutes': estimatedMinutes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'scheduledAt': scheduledAt?.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'sortOrder': sortOrder,
      'isToday': isToday,
      'category': category,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      priority: TaskPriority.values[json['priority']],
      status: TaskStatus.values[json['status']],
      estimatedMinutes: json['estimatedMinutes'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'])
          : null,
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['scheduledAt'])
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['dueDate'])
          : null,
      sortOrder: json['sortOrder'],
      isToday: json['isToday'] ?? false,
      category: json['category'] ?? 'General',
    );
  }

  // 優先度に基づく並び順を取得
  int get priorityOrder {
    switch (priority) {
      case TaskPriority.urgent:
        return 0;
      case TaskPriority.high:
        return 1;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.low:
        return 3;
    }
  }

  // 期日が今日かどうかを判定
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return today == due;
  }

  // 期日が明日かどうかを判定
  bool get isDueTomorrow {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return tomorrow == due;
  }

  // 期日が過ぎているかどうかを判定
  bool get isOverdue {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return due.isBefore(today);
  }
}