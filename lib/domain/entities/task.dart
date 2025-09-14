// lib/domain/entities/task.dart
import 'package:uuid/uuid.dart';

enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final int estimatedMinutes;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final String category;

  Task({
    String? id,
    required this.title,
    this.description = '',
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    required this.estimatedMinutes,
    DateTime? createdAt,
    this.scheduledAt,
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
    DateTime? scheduledAt,
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
      scheduledAt: scheduledAt ?? this.scheduledAt,
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
      'scheduledAt': scheduledAt?.millisecondsSinceEpoch,
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
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['scheduledAt'])
          : null,
      category: json['category'] ?? 'General',
    );
  }
}