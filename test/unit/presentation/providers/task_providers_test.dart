import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/repositories/task_repository.dart';
import 'package:task_aiagent/domain/usecases/task/create_task_usecase.dart';
import 'package:task_aiagent/presentation/providers/task_providers.dart';
import 'package:task_aiagent/core/utils/result.dart';
import 'package:task_aiagent/core/error/failures.dart';

@GenerateMocks([TaskRepository, CreateTaskUseCase])
import 'task_providers_test.mocks.dart';

// テスト用のTaskListNotifier
class TaskListTestNotifier extends TaskList {
  final List<Task> _tasks;
  TaskListTestNotifier(this._tasks);

  @override
  Future<List<Task>> build() async {
    return _tasks;
  }
}

void main() {
  group('Task Providers Tests', () {
    late MockTaskRepository mockRepository;
    late MockCreateTaskUseCase mockCreateUseCase;

    setUp(() {
      mockRepository = MockTaskRepository();
      mockCreateUseCase = MockCreateTaskUseCase();
    });

    group('TaskList Provider', () {
      test('should load tasks successfully on initialization', () async {
        // Arrange
        final testTasks = [
          Task(
            id: '1',
            title: 'Task 1',
            estimatedMinutes: 30,
            priority: TaskPriority.high,
          ),
          Task(
            id: '2',
            title: 'Task 2',
            estimatedMinutes: 45,
            priority: TaskPriority.medium,
          ),
        ];

        when(mockRepository.getAllTasks()).thenAnswer(
          (_) async => Success(testTasks),
        );

        // Create container with overrides
        final container = ProviderContainer(
          overrides: [
            taskRepositoryProvider.overrideWithValue(mockRepository),
          ],
        );

        // Act & Assert
        final result = await container.read(taskListProvider.future);
        expect(result, testTasks);

        verify(mockRepository.getAllTasks()).called(1);
      });

      test('should handle repository failures', () async {
        // Arrange
        when(mockRepository.getAllTasks()).thenAnswer(
          (_) async => ResultFailure(NetworkFailure('Connection failed')),
        );

        final container = ProviderContainer(
          overrides: [
            taskRepositoryProvider.overrideWithValue(mockRepository),
          ],
        );

        // Act & Assert
        try {
          await container.read(taskListProvider.future);
          fail('Expected an exception to be thrown');
        } catch (e) {
          expect(e, anyOf(isA<Exception>(), isA<StateError>()));
        }

        container.dispose();
      });

      test('should create task and update state', () async {
        // Arrange
        final initialTasks = <Task>[];
        final newTask = Task(
          id: '1',
          title: 'New Task',
          estimatedMinutes: 30,
        );

        when(mockRepository.getAllTasks()).thenAnswer(
          (_) async => Success(initialTasks),
        );

        final container = ProviderContainer(
          overrides: [
            taskRepositoryProvider.overrideWithValue(mockRepository),
            createTaskUseCaseProvider.overrideWithValue(mockCreateUseCase),
          ],
        );

        when(mockCreateUseCase.execute(
          title: 'New Task',
          description: '',
          estimatedMinutes: 30,
          priority: TaskPriority.medium,
        )).thenAnswer((_) async => Success(newTask));

        // Wait for initial load
        await container.read(taskListProvider.future);

        // Act
        await container.read(taskListProvider.notifier).createTask(
          title: 'New Task',
          description: '',
          estimatedMinutes: 30,
          priority: TaskPriority.medium,
        );

        // Assert
        final state = await container.read(taskListProvider.future);
        expect(state, contains(newTask));
      });
    });

    group('Computed Providers', () {
      test('activeTasks should filter out completed tasks', () async {
        // Arrange
        final testTasks = [
          Task(
            id: '1',
            title: 'Active Task',
            estimatedMinutes: 30,
            status: TaskStatus.upcoming,
          ),
          Task(
            id: '2',
            title: 'Completed Task',
            estimatedMinutes: 45,
            status: TaskStatus.completed,
          ),
          Task(
            id: '3',
            title: 'In Progress Task',
            estimatedMinutes: 60,
            status: TaskStatus.inProgress,
          ),
        ];

        final container = ProviderContainer(
          overrides: [
            taskListProvider.overrideWith(() => TaskListTestNotifier(testTasks)),
          ],
        );

        // Wait for the async provider to complete
        await container.read(taskListProvider.future);

        // Act
        final activeTasks = container.read(activeTasksProvider);

        // Assert
        expect(activeTasks.length, 2);
        expect(activeTasks.map((t) => t.id), ['1', '3']);

        container.dispose();
      });

      test('completedTasks should return only completed tasks sorted by updated date', () async {
        // Arrange
        final now = DateTime.now();
        final testTasks = [
          Task(
            id: '1',
            title: 'Active Task',
            estimatedMinutes: 30,
            status: TaskStatus.upcoming,
          ),
          Task(
            id: '2',
            title: 'Completed Task 1',
            estimatedMinutes: 45,
            status: TaskStatus.completed,
            updatedAt: now.subtract(const Duration(hours: 1)),
          ),
          Task(
            id: '3',
            title: 'Completed Task 2',
            estimatedMinutes: 60,
            status: TaskStatus.completed,
            updatedAt: now,
          ),
        ];

        final container = ProviderContainer(
          overrides: [
            taskListProvider.overrideWith(() => TaskListTestNotifier(testTasks)),
          ],
        );

        // Wait for the async provider to complete
        await container.read(taskListProvider.future);

        // Act
        final completedTasks = container.read(completedTasksProvider);

        // Assert
        expect(completedTasks.length, 2);
        // Should be sorted by updated time (newest first)
        expect(completedTasks.first.id, '3');
        expect(completedTasks.last.id, '2');

        container.dispose();
      });

      test('taskStats should calculate correct statistics', () async {
        // Arrange
        final today = DateTime.now();
        final testTasks = [
          Task(
            id: '1',
            title: 'Active Task',
            estimatedMinutes: 30,
            status: TaskStatus.upcoming,
          ),
          Task(
            id: '2',
            title: 'Completed Task',
            estimatedMinutes: 45,
            status: TaskStatus.completed,
          ),
          Task(
            id: '3',
            title: 'Urgent Task',
            estimatedMinutes: 60,
            status: TaskStatus.inProgress,
            priority: TaskPriority.urgent,
          ),
          Task(
            id: '4',
            title: 'Today Task',
            estimatedMinutes: 30,
            dueDate: today,
          ),
        ];

        final container = ProviderContainer(
          overrides: [
            taskListProvider.overrideWith(() => TaskListTestNotifier(testTasks)),
          ],
        );

        // Wait for the async provider to complete
        await container.read(taskListProvider.future);

        // Act
        final stats = container.read(taskStatsProvider);

        // Assert
        expect(stats['total'], 4);
        expect(stats['active'], 3); // excluding completed
        expect(stats['completed'], 1);
        expect(stats['urgent'], 1);
        expect(stats['today'], 1);

        container.dispose();
      });

      test('urgentTasks should return only urgent active tasks', () async {
        // Arrange
        final testTasks = [
          Task(
            id: '1',
            title: 'Urgent Active Task',
            estimatedMinutes: 30,
            status: TaskStatus.upcoming,
            priority: TaskPriority.urgent,
          ),
          Task(
            id: '2',
            title: 'Urgent Completed Task',
            estimatedMinutes: 45,
            status: TaskStatus.completed,
            priority: TaskPriority.urgent,
          ),
          Task(
            id: '3',
            title: 'High Priority Task',
            estimatedMinutes: 60,
            status: TaskStatus.upcoming,
            priority: TaskPriority.high,
          ),
        ];

        final container = ProviderContainer(
          overrides: [
            taskListProvider.overrideWith(() => TaskListTestNotifier(testTasks)),
          ],
        );

        // Wait for the async provider to complete
        await container.read(taskListProvider.future);

        // Act
        final urgentTasks = container.read(urgentTasksProvider);

        // Assert
        expect(urgentTasks.length, 1);
        expect(urgentTasks.first.id, '1');
        expect(urgentTasks.first.priority, TaskPriority.urgent);
        expect(urgentTasks.first.status, TaskStatus.upcoming);

        container.dispose();
      });
    });
  });
}