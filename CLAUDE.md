# TimeFlow - 開発規約・テスト規約

## 📋 目次
- [コード規約](#コード規約)
- [アーキテクチャ規約](#アーキテクチャ規約)
- [テスト規約](#テスト規約)
- [命名規則](#命名規則)
- [コミット規約](#コミット規約)
- [プルリクエスト規約](#プルリクエスト規約)
- [AI開発ツール向けガイド](#ai開発ツール向けガイド)

## 🛠️ コード規約

### Dartコード規約

#### 基本原則
- **Clean Architecture**の原則に従った構造化
- **SOLID原則**の遵守
- **DRY（Don't Repeat Yourself）**の徹底
- **YAGNI（You Aren't Gonna Need It）**の考慮

#### フォーマット・Lint
```bash
# コードフォーマット
flutter format .

# Lint チェック
flutter analyze

# 推奨Lintルール
dart_code_metrics: ^5.7.6
very_good_analysis: ^5.1.0
```

#### コメント規約
```dart
// ✅ Good: 明確で簡潔なコメント
/// ユーザーのタスクを管理するための主要なリポジトリ
/// 
/// このクラスは以下の責務を持つ：
/// - タスクのCRUD操作
/// - ローカル・リモート同期
class TaskRepository {
  // 実装
}

// ❌ Bad: 不要または不明確なコメント
// タスクを取得する
Future<List<Task>> getTasks() async {
  // 実装
}
```

#### エラーハンドリング
```dart
// ✅ Good: 具体的なエラーハンドリング
try {
  final result = await taskRepository.updateTask(task);
  return Right(result);
} on NetworkException catch (e) {
  return Left(NetworkFailure(message: e.message));
} on CacheException catch (e) {
  return Left(CacheFailure(message: e.message));
} catch (e) {
  return Left(UnexpectedFailure(message: e.toString()));
}

// ❌ Bad: 曖昧なエラーハンドリング
try {
  // 処理
} catch (e) {
  print(e); // ログ出力のみ
}
```

### Flutter UI規約

#### Widget構成
```dart
// ✅ Good: 適切なWidget分割
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  
  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}

// ❌ Bad: 巨大なbuildメソッド
class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 200行以上のネストしたWidget...
    );
  }
}
```

#### 状態管理規約
```dart
// ✅ Good: Riverpodを使用した適切な状態管理
@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  List<Task> build() => [];
  
  Future<void> addTask(Task task) async {
    state = [...state, task];
    await ref.read(taskRepositoryProvider).saveTask(task);
  }
}

// ❌ Bad: StatefulWidgetでの複雑な状態管理
class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  // 複雑な状態ロジック...
}
```

## 🏗️ アーキテクチャ規約

### Clean Architecture構造
```
lib/
├── core/                    # 共通コア機能
├── data/                    # データレイヤー
│   ├── datasources/         # データソース（local/remote/ai）
│   ├── models/              # データモデル
│   └── repositories/        # リポジトリ実装
├── domain/                  # ドメインレイヤー
│   ├── entities/            # エンティティ
│   ├── repositories/        # リポジトリインターフェース
│   └── usecases/            # ユースケース
├── presentation/            # プレゼンテーションレイヤー
│   ├── pages/               # 画面
│   ├── widgets/             # ウィジェット
│   └── providers/           # 状態管理
└── services/                # 外部サービス
```

### 依存関係の規則
- **Domain層**: 他の層に依存しない
- **Data層**: Domainのみに依存
- **Presentation層**: DomainとDataに依存可能
- **外側から内側への依存のみ許可**

### ファイル命名規則
```dart
// エンティティ
domain/entities/task.dart
domain/entities/user.dart

// リポジトリ
domain/repositories/task_repository.dart
data/repositories/task_repository_impl.dart

// ユースケース
domain/usecases/create_task_usecase.dart
domain/usecases/get_tasks_usecase.dart

// プロバイダー
presentation/providers/task_provider.dart
presentation/providers/auth_provider.dart
```

## 🧪 テスト規約

### テストカバレッジ目標
- **単体テスト**: 80%以上
- **統合テスト**: 主要フロー100%
- **ウィジェットテスト**: 主要画面100%

### テスト構造
```
test/
├── unit/                    # 単体テスト
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   └── repositories/
│   └── services/
├── widget/                  # ウィジェットテスト
│   ├── pages/
│   └── widgets/
├── integration/             # 統合テスト
│   ├── auth_flow_test.dart
│   ├── task_management_test.dart
│   └── schedule_generation_test.dart
└── helpers/                 # テストヘルパー
    ├── mock_data.dart
    ├── test_doubles.dart
    └── test_utils.dart
```

### テスト記述規約
```dart
// ✅ Good: 明確なテスト構造
group('TaskRepository', () {
  late TaskRepository repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = TaskRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('getTasks', () {
    test('should return list of tasks when call to data source is successful', () async {
      // arrange
      final tTaskList = [
        Task(id: '1', title: 'Test Task', estimatedMinutes: 30),
      ];
      when(() => mockLocalDataSource.getTasks())
          .thenAnswer((_) async => tTaskList);

      // act
      final result = await repository.getTasks();

      // assert
      expect(result, equals(Right(tTaskList)));
      verify(() => mockLocalDataSource.getTasks()).called(1);
    });

    test('should return cache failure when call to data source fails', () async {
      // arrange
      when(() => mockLocalDataSource.getTasks())
          .thenThrow(CacheException());

      // act
      final result = await repository.getTasks();

      // assert
      expect(result, equals(Left(CacheFailure())));
    });
  });
});
```

### モック・テストダブル規約
```dart
// ✅ Good: 適切なモック使用
@GenerateMocks([
  TaskRepository,
  LocalStorageService,
  ScheduleGeneratorService,
])
void main() {}

// テストでのモック使用
test('should generate schedule when tasks are provided', () async {
  // arrange
  final mockTasks = [createMockTask()];
  when(() => mockTaskRepository.getTasks())
      .thenAnswer((_) async => Right(mockTasks));

  // act
  final result = await usecase.generateSchedule(DateTime.now());

  // assert
  expect(result.isRight(), true);
  verify(() => mockTaskRepository.getTasks()).called(1);
});
```

### Golden Test規約
```dart
// UI回帰テスト
testWidgets('TaskCard should match golden file', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TaskCard(
        task: createMockTask(),
      ),
    ),
  );

  await expectLater(
    find.byType(TaskCard),
    matchesGoldenFile('task_card.png'),
  );
});
```

## 📝 命名規則

### 変数・関数命名
```dart
// ✅ Good: 明確で説明的な名前
final taskRepository = TaskRepositoryImpl();
final userPreferences = UserPreferencesService();
final scheduleGenerationResult = await generateSchedule();

bool isTaskCompleted(Task task) => task.status == TaskStatus.completed;
Future<void> saveTaskToLocalStorage(Task task) async { /* ... */ }

// ❌ Bad: 曖昧な名前
final repo = TaskRepositoryImpl();
final prefs = UserPreferencesService();
final result = await generate();

bool check(Task task) => task.status == TaskStatus.completed;
Future<void> save(Task task) async { /* ... */ }
```

### クラス命名
```dart
// エンティティ
class Task { }
class User { }
class Schedule { }

// リポジトリ
abstract class TaskRepository { }
class TaskRepositoryImpl implements TaskRepository { }

// ユースケース
class CreateTaskUseCase { }
class GenerateScheduleUseCase { }

// プロバイダー
class TaskNotifier extends StateNotifier<List<Task>> { }
class AuthNotifier extends StateNotifier<AuthState> { }

// ウィジェット
class TaskCard extends StatelessWidget { }
class ScheduleView extends StatefulWidget { }

// サービス
class LocalStorageService { }
class NotificationService { }
```

## 📋 コミット規約

### コミットメッセージ形式
```
<type>(<scope>): <description>

<body>

<footer>
```

### タイプ一覧
- **feat**: 新機能
- **fix**: バグ修正
- **docs**: ドキュメント変更
- **style**: コードスタイル変更（機能に影響なし）
- **refactor**: リファクタリング
- **test**: テスト追加・修正
- **chore**: ビルドプロセス・補助ツール変更

### 例
```bash
feat(task): add AI schedule generation feature

- Implement ScheduleGeneratorService
- Add schedule optimization algorithms
- Create schedule persistence layer

Closes #123
```

## 🔄 プルリクエスト規約

### PRテンプレート
```markdown
## 概要
<!-- 変更内容の概要を記述 -->

## 変更内容
- [ ] 新機能追加
- [ ] バグ修正
- [ ] リファクタリング
- [ ] ドキュメント更新

## テスト
- [ ] 単体テスト追加・更新
- [ ] ウィジェットテスト追加・更新
- [ ] 統合テスト確認
- [ ] 手動テスト完了

## チェックリスト
- [ ] コードレビュー自己確認済み
- [ ] Lint・Format確認済み
- [ ] 関連ドキュメント更新済み
- [ ] 破壊的変更がある場合、Migration Guide作成済み

## スクリーンショット
<!-- UI変更がある場合は、Before/Afterのスクリーンショットを添付 -->

## 関連Issue
Closes #[issue番号]
```

### レビュー観点
1. **機能要件**: 仕様通りに動作するか
2. **非機能要件**: パフォーマンス・セキュリティ考慮
3. **コード品質**: 可読性・保守性・拡張性
4. **テスト**: 適切なテストカバレッジ
5. **アーキテクチャ**: 設計原則遵守

## 🤖 AI開発ツール向けガイド

### Claude Code / Gemini CLI 使用時の指針

#### プロジェクト理解のためのコンテキスト
```bash
# プロジェクト構造の把握
find lib -name "*.dart" | head -20

# 主要ファイルの確認
cat lib/main.dart
cat lib/domain/entities/task.dart
cat lib/presentation/providers/task_provider.dart
```

#### 開発タスクの指示例
```bash
# 新機能開発
"lib/domain/entities/schedule.dartに基づいて、週次スケジュール機能を追加してください。Clean Architectureの原則に従い、domain/usecases/generate_weekly_schedule_usecase.dartを作成し、適切なテストも含めてください。"

# バグ修正
"TaskCardウィジェットで優先度の色が正しく表示されない問題を修正してください。lib/presentation/widgets/task/task_card.dartを確認し、_getPriorityColor関数の実装を修正してください。"

# テスト追加
"ScheduleGeneratorServiceのテストが不足しています。test/unit/services/ai/schedule_generator_test.dartを作成し、エッジケースを含む包括的なテストを書いてください。"
```

#### コード生成時の制約
1. **既存コードとの整合性**: 既存のコード規約・パターンに従う
2. **依存関係の尊重**: Clean Architectureの依存関係ルールを守る
3. **テストファースト**: 新機能には必ずテストを含める
4. **型安全性**: null safetyとstrong typingを徹底
5. **国際化対応**: ハードコードされた文字列を避ける

#### 推奨プロンプトパターン
```
"[機能名]を実装してください。

要件:
- Clean Architectureに従った構造
- Riverpodを使用した状態管理
- 適切なエラーハンドリング
- 単体テスト・ウィジェットテスト含む
- 既存のコード規約に準拠

ファイル構成:
- domain/entities/
- domain/usecases/
- data/repositories/
- presentation/providers/
- presentation/widgets/
- test/unit/
- test/widget/"
```

### CI/CD連携
```yaml
# .github/workflows/ai_code_check.yml
name: AI Generated Code Check

on:
  pull_request:
    paths:
      - 'lib/**'
      - 'test/**'

jobs:
  code-quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - run: flutter test integration_test/
```

### 品質チェックポイント
1. **アーキテクチャ準拠**: 依存関係の方向性確認
2. **命名規則**: ファイル名・クラス名・変数名の一貫性
3. **テストカバレッジ**: 新規コードの80%以上カバー
4. **パフォーマンス**: Big O記法での計算量確認
5. **セキュリティ**: 入力検証・認証・認可の実装

これらの規約に従って、一貫性のある高品質なコードベースを維持してください。