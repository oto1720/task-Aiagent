import 'package:flutter_test/flutter_test.dart';
import 'package:task_aiagent/domain/entities/task.dart';

void main() {
  group('Task Entity Tests', () {
    test('should create a task with default values', () {
      // Arrange
      const title = 'Test Task';
      const estimatedMinutes = 30;

      // Act
      final task = Task(
        title: title,
        estimatedMinutes: estimatedMinutes,
      );

      // Assert
      expect(task.title, title);
      expect(task.estimatedMinutes, estimatedMinutes);
      expect(task.status, TaskStatus.upcoming);
      expect(task.priority, TaskPriority.medium);
      expect(task.description, '');
      expect(task.category, 'General');
      expect(task.isToday, false);
    });

    test('should create task from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'test-id',
        'title': 'Test Task',
        'description': 'Test Description',
        'priority': 1, // TaskPriority.high
        'status': 0, // TaskStatus.upcoming
        'estimatedMinutes': 45,
        'createdAt': DateTime(2024, 1, 1).millisecondsSinceEpoch,
        'isToday': true,
        'category': 'Work',
      };

      // Act
      final task = Task.fromJson(json);

      // Assert
      expect(task.id, 'test-id');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.priority, TaskPriority.high);
      expect(task.status, TaskStatus.upcoming);
      expect(task.estimatedMinutes, 45);
      expect(task.isToday, true);
      expect(task.category, 'Work');
    });

    test('should convert task to JSON correctly', () {
      // Arrange
      final createdAt = DateTime(2024, 1, 1);
      final task = Task(
        id: 'test-id',
        title: 'Test Task',
        description: 'Test Description',
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        estimatedMinutes: 60,
        createdAt: createdAt,
        isToday: true,
        category: 'Work',
      );

      // Act
      final json = task.toJson();

      // Assert
      expect(json['id'], 'test-id');
      expect(json['title'], 'Test Task');
      expect(json['description'], 'Test Description');
      expect(json['priority'], 1); // TaskPriority.high.index
      expect(json['status'], 1); // TaskStatus.inProgress.index
      expect(json['estimatedMinutes'], 60);
      expect(json['createdAt'], createdAt.millisecondsSinceEpoch);
      expect(json['isToday'], true);
      expect(json['category'], 'Work');
    });

    test('should correctly identify due date status', () {
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));
      final yesterday = today.subtract(const Duration(days: 1));

      // Today's task
      final todayTask = Task(
        title: 'Today Task',
        estimatedMinutes: 30,
        dueDate: today,
      );

      // Tomorrow's task
      final tomorrowTask = Task(
        title: 'Tomorrow Task',
        estimatedMinutes: 30,
        dueDate: tomorrow,
      );

      // Overdue task
      final overdueTask = Task(
        title: 'Overdue Task',
        estimatedMinutes: 30,
        dueDate: yesterday,
      );

      expect(todayTask.isDueToday, true);
      expect(todayTask.isDueTomorrow, false);
      expect(todayTask.isOverdue, false);

      expect(tomorrowTask.isDueToday, false);
      expect(tomorrowTask.isDueTomorrow, true);
      expect(tomorrowTask.isOverdue, false);

      expect(overdueTask.isDueToday, false);
      expect(overdueTask.isDueTomorrow, false);
      expect(overdueTask.isOverdue, true);
    });

    test('should return correct priority order', () {
      final urgentTask = Task(title: 'Urgent', estimatedMinutes: 30, priority: TaskPriority.urgent);
      final highTask = Task(title: 'High', estimatedMinutes: 30, priority: TaskPriority.high);
      final mediumTask = Task(title: 'Medium', estimatedMinutes: 30, priority: TaskPriority.medium);
      final lowTask = Task(title: 'Low', estimatedMinutes: 30, priority: TaskPriority.low);

      expect(urgentTask.priorityOrder, 0);
      expect(highTask.priorityOrder, 1);
      expect(mediumTask.priorityOrder, 2);
      expect(lowTask.priorityOrder, 3);
    });

    test('should copy task with modified properties', () {
      // Arrange
      final originalTask = Task(
        title: 'Original Task',
        estimatedMinutes: 30,
        priority: TaskPriority.low,
      );

      // Act
      final copiedTask = originalTask.copyWith(
        title: 'Modified Task',
        priority: TaskPriority.high,
      );

      // Assert
      expect(copiedTask.title, 'Modified Task');
      expect(copiedTask.priority, TaskPriority.high);
      expect(copiedTask.estimatedMinutes, 30); // unchanged
      expect(copiedTask.id, originalTask.id); // unchanged
    });
  });
}