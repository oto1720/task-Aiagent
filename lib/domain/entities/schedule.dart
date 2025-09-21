// lib/domain/entities/schedule.dart
import 'package:uuid/uuid.dart';
import 'package:task_aiagent/domain/entities/task.dart';

enum ScheduleItemType {
  task,
  breakTime,
  meeting,
  other,
}

// 新しいScheduleItemクラス（UseCase層で使用）
class ScheduleItem {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final ScheduleItemType type;
  final TaskPriority? priority;
  final int? estimatedMinutes;

  ScheduleItem({
    String? id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.priority,
    this.estimatedMinutes,
  }) : id = id ?? const Uuid().v4();

  ScheduleItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    ScheduleItemType? type,
    TaskPriority? priority,
    int? estimatedMinutes,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }

  int get durationInMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'type': type.index,
      'priority': priority?.index,
      'estimatedMinutes': estimatedMinutes,
    };
  }

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(json['endTime']),
      type: ScheduleItemType.values[json['type']],
      priority: json['priority'] != null ? TaskPriority.values[json['priority']] : null,
      estimatedMinutes: json['estimatedMinutes'],
    );
  }
}

// 既存のScheduleBlockクラス（後方互換性のため維持）
class ScheduleBlock {
  final String id;
  final String taskId;
  final DateTime startTime;
  final DateTime endTime;
  final String taskTitle;
  final TaskPriority priority;

  ScheduleBlock({
    String? id,
    required this.taskId,
    required this.startTime,
    required this.endTime,
    required this.taskTitle,
    required this.priority,
  }) : id = id ?? const Uuid().v4();

  ScheduleBlock copyWith({
    String? id,
    String? taskId,
    DateTime? startTime,
    DateTime? endTime,
    String? taskTitle,
    TaskPriority? priority,
  }) {
    return ScheduleBlock(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      taskTitle: taskTitle ?? this.taskTitle,
      priority: priority ?? this.priority,
    );
  }

  int get durationInMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'taskTitle': taskTitle,
      'priority': priority.index,
    };
  }

  factory ScheduleBlock.fromJson(Map<String, dynamic> json) {
    return ScheduleBlock(
      id: json['id'],
      taskId: json['taskId'],
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(json['endTime']),
      taskTitle: json['taskTitle'],
      priority: TaskPriority.values[json['priority']],
    );
  }
}

class DailySchedule {
  final String id;
  final DateTime date;
  final List<ScheduleBlock> blocks;
  final List<ScheduleItem> items; // 新しいScheduleItem形式
  final int totalWorkingMinutes;
  final DateTime createdAt;

  DailySchedule({
    String? id,
    required this.date,
    List<ScheduleBlock>? blocks,
    List<ScheduleItem>? items,
    this.totalWorkingMinutes = 0,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        blocks = blocks ?? [],
        items = items ?? [],
        createdAt = createdAt ?? DateTime.now();

  DailySchedule copyWith({
    String? id,
    DateTime? date,
    List<ScheduleBlock>? blocks,
    List<ScheduleItem>? items,
    int? totalWorkingMinutes,
    DateTime? createdAt,
  }) {
    return DailySchedule(
      id: id ?? this.id,
      date: date ?? this.date,
      blocks: blocks ?? this.blocks,
      items: items ?? this.items,
      totalWorkingMinutes: totalWorkingMinutes ?? this.totalWorkingMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'blocks': blocks.map((block) => block.toJson()).toList(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalWorkingMinutes': totalWorkingMinutes,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory DailySchedule.fromJson(Map<String, dynamic> json) {
    return DailySchedule(
      id: json['id'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      blocks: json['blocks'] != null
          ? (json['blocks'] as List<dynamic>)
              .map((blockJson) => ScheduleBlock.fromJson(blockJson))
              .toList()
          : [],
      items: json['items'] != null
          ? (json['items'] as List<dynamic>)
              .map((itemJson) => ScheduleItem.fromJson(itemJson))
              .toList()
          : [],
      totalWorkingMinutes: json['totalWorkingMinutes'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }
}