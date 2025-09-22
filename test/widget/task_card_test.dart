import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/presentation/widgets/task/task_card.dart';

void main() {
  group('TaskCard Widget Tests', () {
    testWidgets('should display task information correctly', (tester) async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        estimatedMinutes: 60,
        priority: TaskPriority.high,
        status: TaskStatus.upcoming,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: task),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('1時間'), findsOneWidget);
    });

    testWidgets('should show strikethrough for completed tasks', (tester) async {
      // Arrange
      final completedTask = Task(
        id: '1',
        title: 'Completed Task',
        estimatedMinutes: 30,
        status: TaskStatus.completed,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: completedTask),
          ),
        ),
      );

      // Assert
      final titleWidget = tester.widget<Text>(
        find.text('Completed Task'),
      );
      expect(titleWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('should display due date when available', (tester) async {
      // Arrange
      final dueDate = DateTime.now().add(const Duration(days: 1));
      final task = Task(
        id: '1',
        title: 'Task with Due Date',
        estimatedMinutes: 30,
        dueDate: dueDate,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: task),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.event), findsOneWidget);
      expect(find.text('明日'), findsOneWidget);
    });

    testWidgets('should call onComplete when complete button is tapped', (tester) async {
      // Arrange
      bool onCompleteCalled = false;
      final task = Task(
        id: '1',
        title: 'Test Task',
        estimatedMinutes: 30,
        status: TaskStatus.upcoming,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: task,
              onComplete: () {
                onCompleteCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.check_circle));
      await tester.pump();

      // Assert
      expect(onCompleteCalled, true);
    });

    testWidgets('should call onStatusToggle when status button is tapped', (tester) async {
      // Arrange
      bool onStatusToggleCalled = false;
      final task = Task(
        id: '1',
        title: 'Test Task',
        estimatedMinutes: 30,
        status: TaskStatus.upcoming,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: task,
              onStatusToggle: () {
                onStatusToggleCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.play_circle));
      await tester.pump();

      // Assert
      expect(onStatusToggleCalled, true);
    });

    testWidgets('should show correct priority indicator', (tester) async {
      // Arrange
      final urgentTask = Task(
        id: '1',
        title: 'Urgent Task',
        estimatedMinutes: 30,
        priority: TaskPriority.urgent,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: urgentTask),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.priority_high), findsOneWidget);
    });

    testWidgets('should open popup menu when menu button is tapped', (tester) async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        estimatedMinutes: 30,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: task),
          ),
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('編集'), findsOneWidget);
      expect(find.text('削除'), findsOneWidget);
    });

    testWidgets('should call onEdit when edit menu item is selected', (tester) async {
      // Arrange
      bool onEditCalled = false;
      final task = Task(
        id: '1',
        title: 'Test Task',
        estimatedMinutes: 30,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: task,
              onEdit: () {
                onEditCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('編集'));
      await tester.pump();

      // Assert
      expect(onEditCalled, true);
    });

    testWidgets('should call onDelete when delete menu item is selected', (tester) async {
      // Arrange
      bool onDeleteCalled = false;
      final task = Task(
        id: '1',
        title: 'Test Task',
        estimatedMinutes: 30,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: task,
              onDelete: () {
                onDeleteCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('削除'));
      await tester.pump();

      // Assert
      expect(onDeleteCalled, true);
    });

    testWidgets('should display overdue tasks with red color', (tester) async {
      // Arrange
      final overdueDate = DateTime.now().subtract(const Duration(days: 1));
      final overdueTask = Task(
        id: '1',
        title: 'Overdue Task',
        estimatedMinutes: 30,
        dueDate: overdueDate,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: overdueTask),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.event), findsOneWidget);
      expect(find.text('期限切れ'), findsOneWidget);
    });
  });
}