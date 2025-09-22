import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/repositories/task_repository.dart';
import 'package:task_aiagent/domain/usecases/task/create_task_usecase.dart';
import 'package:task_aiagent/core/utils/result.dart';
import 'package:task_aiagent/core/error/failures.dart';

// Generate mocks
@GenerateMocks([TaskRepository])
import 'create_task_usecase_test.mocks.dart';

void main() {
  group('CreateTaskUseCase Tests', () {
    late CreateTaskUseCase useCase;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      useCase = CreateTaskUseCase(taskRepository: mockRepository);
    });

    test('should create task successfully when all validations pass', () async {
      // Arrange
      const title = 'Test Task';
      const description = 'Test Description';
      const estimatedMinutes = 60;
      const priority = TaskPriority.high;

      final expectedTask = Task(
        title: title,
        description: description,
        estimatedMinutes: estimatedMinutes,
        priority: priority,
      );

      when(mockRepository.getAllTasks()).thenAnswer(
        (_) async => Success([]), // No existing tasks
      );
      when(mockRepository.createTask(any)).thenAnswer(
        (_) async => Success(expectedTask),
      );

      // Act
      final result = await useCase.execute(
        title: title,
        description: description,
        estimatedMinutes: estimatedMinutes,
        priority: priority,
      );

      // Assert
      expect(result.isSuccess, true);
      expect(result.value.title, title);
      expect(result.value.description, description);
      expect(result.value.estimatedMinutes, estimatedMinutes);
      expect(result.value.priority, priority);
      
      verify(mockRepository.getAllTasks()).called(1);
      verify(mockRepository.createTask(any)).called(1);
    });

    test('should fail when duplicate task exists', () async {
      // Arrange
      const title = 'Existing Task';
      final existingTask = Task(
        title: title,
        estimatedMinutes: 30,
        status: TaskStatus.upcoming,
      );

      when(mockRepository.getAllTasks()).thenAnswer(
        (_) async => Success([existingTask]),
      );

      // Act
      final result = await useCase.execute(
        title: title,
        description: '',
        estimatedMinutes: 60,
        priority: TaskPriority.medium,
      );

      // Assert
      expect(result.isFailure, true);
      expect(result.failure, isA<ValidationFailure>());
      expect(
        result.failure.message,
        contains('同じ名前の未完了タスクが既に存在します'),
      );
      
      verify(mockRepository.getAllTasks()).called(1);
      verifyNever(mockRepository.createTask(any));
    });

    test('should fail when daily work time limit exceeded', () async {
      // Arrange
      final dueDate = DateTime.now().add(const Duration(days: 1));
      final existingTask = Task(
        title: 'Existing Task',
        estimatedMinutes: 400, // 6.67 hours
        dueDate: dueDate,
        status: TaskStatus.upcoming,
      );

      when(mockRepository.getAllTasks()).thenAnswer(
        (_) async => Success([]),
      );
      when(mockRepository.getTasksForDate(dueDate)).thenAnswer(
        (_) async => Success([existingTask]),
      );

      // Act
      final result = await useCase.execute(
        title: 'New Task',
        description: '',
        estimatedMinutes: 120, // 2 hours, total would be 8.67 hours
        priority: TaskPriority.medium,
        dueDate: dueDate,
      );

      // Assert
      expect(result.isFailure, true);
      expect(result.failure, isA<ValidationFailure>());
      expect(
        result.failure.message,
        contains('指定日の作業時間が制限（8時間）を超過します'),
      );
    });

    test('should fail when too many urgent tasks exist', () async {
      // Arrange
      final urgentTasks = List.generate(3, (index) => Task(
        title: 'Urgent Task $index',
        estimatedMinutes: 30,
        priority: TaskPriority.urgent,
        status: TaskStatus.upcoming,
      ));

      when(mockRepository.getAllTasks()).thenAnswer(
        (_) async => Success(urgentTasks),
      );

      // Act
      final result = await useCase.execute(
        title: 'Another Urgent Task',
        description: '',
        estimatedMinutes: 60,
        priority: TaskPriority.urgent,
      );

      // Assert
      expect(result.isFailure, true);
      expect(result.failure, isA<ValidationFailure>());
      expect(
        result.failure.message,
        contains('緊急タスクは同時に3個まで設定できます'),
      );
    });

    test('should propagate repository failures', () async {
      // Arrange
      const failureMessage = 'Database connection failed';
      when(mockRepository.getAllTasks()).thenAnswer(
        (_) async => ResultFailure(NetworkFailure(failureMessage)),
      );

      // Act
      final result = await useCase.execute(
        title: 'Test Task',
        description: '',
        estimatedMinutes: 30,
        priority: TaskPriority.medium,
      );

      // Assert
      expect(result.isFailure, true);
      expect(result.failure, isA<NetworkFailure>());
      expect(result.failure.message, failureMessage);
    });

    test('should allow creating task with same title as completed task', () async {
      // Arrange
      const title = 'Completed Task';
      final completedTask = Task(
        title: title,
        estimatedMinutes: 30,
        status: TaskStatus.completed, // Completed task
      );
      
      final newTask = Task(
        title: title,
        estimatedMinutes: 60,
        priority: TaskPriority.medium,
      );

      when(mockRepository.getAllTasks()).thenAnswer(
        (_) async => Success([completedTask]),
      );
      when(mockRepository.createTask(any)).thenAnswer(
        (_) async => Success(newTask),
      );

      // Act
      final result = await useCase.execute(
        title: title,
        description: '',
        estimatedMinutes: 60,
        priority: TaskPriority.medium,
      );

      // Assert
      expect(result.isSuccess, true);
      verify(mockRepository.createTask(any)).called(1);
    });
  });
}