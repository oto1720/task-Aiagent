// lib/domain/entities/schedule.dart
import 'package:uuid/uuid.dart';
import 'package:task_aiagent/domain/entities/task.dart';

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
  final DateTime createdAt;

  DailySchedule({
    String? id,
    required this.date,
    required this.blocks,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  DailySchedule copyWith({
    String? id,
    DateTime? date,
    List<ScheduleBlock>? blocks,
    DateTime? createdAt,
  }) {
    return DailySchedule(
      id: id ?? this.id,
      date: date ?? this.date,
      blocks: blocks ?? this.blocks,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'blocks': blocks.map((block) => block.toJson()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory DailySchedule.fromJson(Map<String, dynamic> json) {
    return DailySchedule(
      id: json['id'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      blocks: (json['blocks'] as List<dynamic>)
          .map((blockJson) => ScheduleBlock.fromJson(blockJson))
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }
}