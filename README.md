# TimeFlow - AIタスク管理アプリ

TimeFlowは、AIエージェントが個人の特性と行動パターンを学習し、実行可能で継続しやすい時間割を自動生成するタスク管理アプリケーションです。

## プロダクト概要

### 目的・ビジョン
ユーザーが1日のやりたいことを入力するだけで、AIが個人最適化された時間割を自動生成し、実行しやすく継続可能なタスク管理体験を提供します。

### 解決する課題
- タスクの優先順位付けや時間配分が苦手
- 計画は立てられるが実行に移せない
- 自分に適した作業ペースが分からない
- タスク管理が継続できない

## 技術スタック

### フロントエンド
- **Flutter** (iOS/Android対応)
- **状態管理**: Riverpod
- **UI/UX**: Material Design 3.0

### バックエンド
- **Firebase** (認証、データベース、ストレージ)
- **Cloud Functions** (サーバーレス処理)
- **AI/ML**: TensorFlow Lite

### 開発・運用
- **CI/CD**: GitHub Actions
- **バージョン管理**: Git
- **プロジェクト管理**: Linear/Notion

## ディレクトリ構造

```
lib/
├── main.dart                          # アプリケーションエントリーポイント
├── core/                              # 共通コア機能
│   ├── constants/                     # 定数定義
│   ├── errors/                        # エラーハンドリング
│   ├── utils/                         # ユーティリティ
│   └── config/                        # アプリ設定
├── data/                              # データレイヤー
│   ├── datasources/                   # データソース
│   │   ├── local/                     # ローカルデータ（SQLite、SharedPreferences）
│   │   ├── remote/                    # リモートデータ（Firebase、API）
│   │   └── ai/                        # AI関連データソース
│   ├── models/                        # データモデル
│   │   ├── user/                      # ユーザー関連モデル
│   │   ├── task/                      # タスク関連モデル
│   │   ├── schedule/                  # スケジュール関連モデル
│   │   └── analytics/                 # 分析関連モデル
│   └── repositories/                  # リポジトリ実装
│       ├── user_repository_impl.dart
│       ├── task_repository_impl.dart
│       ├── schedule_repository_impl.dart
│       └── analytics_repository_impl.dart
├── domain/                            # ドメインレイヤー
│   ├── entities/                      # ドメインエンティティ
│   │   ├── user.dart
│   │   ├── task.dart
│   │   ├── schedule.dart
│   │   └── analytics.dart
│   ├── repositories/                  # リポジトリインターフェース
│   │   ├── user_repository.dart
│   │   ├── task_repository.dart
│   │   ├── schedule_repository.dart
│   │   └── analytics_repository.dart
│   └── usecases/                      # ユースケース
│       ├── auth/                      # 認証関連
│       ├── task_management/           # タスク管理
│       ├── schedule_generation/       # スケジュール生成
│       ├── analytics/                 # 分析機能
│       └── calendar_integration/      # カレンダー連携
├── presentation/                      # プレゼンテーションレイヤー
│   ├── pages/                         # 画面（既存ファイルを拡張）
│   │   ├── splash.dart               # スプラッシュ画面
│   │   ├── home.dart                 # ホーム画面
│   │   ├── task.dart                 # タスク管理画面
│   │   ├── calendar.dart             # カレンダー画面
│   │   ├── timer.dart                # タイマー画面
│   │   ├── statistic.dart            # 統計画面
│   │   ├── auth/                     # 認証関連画面
│   │   │   ├── login.dart
│   │   │   └── profile_setup.dart
│   │   └── settings/                 # 設定画面
│   │       ├── user_profile.dart
│   │       ├── preferences.dart
│   │       └── calendar_integration.dart
│   ├── widgets/                       # 再利用可能なウィジェット
│   │   ├── common/                    # 共通ウィジェット
│   │   ├── task/                      # タスク関連ウィジェット
│   │   ├── schedule/                  # スケジュール関連ウィジェット
│   │   ├── timer/                     # タイマー関連ウィジェット
│   │   └── analytics/                 # 分析関連ウィジェット
│   └── providers/                     # Riverpodプロバイダー
│       ├── auth_provider.dart
│       ├── task_provider.dart
│       ├── schedule_provider.dart
│       ├── timer_provider.dart
│       └── analytics_provider.dart
└── services/                          # サービスレイヤー
    ├── ai/                           # AI関連サービス
    │   ├── schedule_generator.dart
    │   ├── pattern_analyzer.dart
    │   └── optimization_engine.dart
    ├── notification/                 # 通知サービス
    ├── calendar/                     # カレンダー連携サービス
    ├── storage/                      # ストレージサービス
    └── analytics/                    # 分析サービス
```

## 開発手順とマイルストーン

### Phase 1: プロジェクトセットアップとMVP基盤 (1-2週間)

#### 1.1 プロジェクト初期設定
- [ ] 依存関係の設定（pubspec.yaml更新）
- [ ] Firebaseプロジェクトセットアップ
- [ ] CI/CDパイプライン構築
- [ ] コードスタイル・Lint設定

#### 1.2 アーキテクチャ基盤構築
- [ ] Clean Architectureの基盤実装
- [ ] Riverpod状態管理の初期設定
- [ ] ルーティング設定
- [ ] エラーハンドリング機構

#### 1.3 認証システム
- [ ] Firebase Authentication統合
- [ ] ログイン/ログアウト機能
- [ ] ユーザープロフィール基本設定

### Phase 2: コア機能開発 (3-4週間)

#### 2.1 タスク管理機能
- [ ] タスクCRUD操作
- [ ] カテゴリー管理
- [ ] 優先度設定
- [ ] 所要時間設定

#### 2.2 ユーザープロフィール詳細設定
- [ ] 基本情報設定（起床時間、就寝時間など）
- [ ] 性格特性設定（集中持続時間、休憩頻度など）
- [ ] 制約条件設定（固定予定、移動時間など）

#### 2.3 基本スケジュール生成
- [ ] ルールベースのスケジュール生成エンジン
- [ ] タイムブロック表示機能
- [ ] 手動調整機能

### Phase 3: AI機能とタイマー統合 (2-3週間)

#### 3.1 AIスケジュール生成
- [ ] TensorFlow Liteモデル統合
- [ ] ユーザーパターン学習機能
- [ ] 最適化エンジン実装

#### 3.2 タイマー・トラッキング機能
- [ ] ポモドーロタイマー実装
- [ ] タスク実行時間記録
- [ ] 実績データ蓄積

#### 3.3 学習・最適化機能
- [ ] 実行データからの学習
- [ ] スケジュール精度向上
- [ ] パーソナライゼーション

### Phase 4: 統計・分析機能 (2週間)

#### 4.1 基本統計機能
- [ ] 日次・週次・月次統計
- [ ] タスク完了率分析
- [ ] カテゴリー別時間配分
- [ ] 集中力パターン分析

#### 4.2 可視化機能
- [ ] グラフ表示（円グラフ、棒グラフ、折れ線グラフ）
- [ ] ヒートマップ表示
- [ ] 達成度表示

### Phase 5: カレンダー連携と通知 (1-2週間)

#### 5.1 カレンダー統合
- [ ] Google Calendar API統合
- [ ] iCloud Calendar連携
- [ ] Outlook Calendar連携
- [ ] 双方向同期機能

#### 5.2 通知システム
- [ ] ローカル通知実装
- [ ] プッシュ通知設定
- [ ] リマインド機能

### Phase 6: 最適化とリリース準備 (1-2週間)

#### 6.1 パフォーマンス最適化
- [ ] アプリ起動時間最適化
- [ ] メモリ使用量最適化
- [ ] バッテリー消費最適化

#### 6.2 品質保証
- [ ] 単体テスト実装
- [ ] 統合テスト実装
- [ ] UIテスト実装
- [ ] パフォーマンステスト

#### 6.3 リリース準備
- [ ] App Store/Google Play Store用アセット準備
- [ ] プライバシーポリシー作成
- [ ] 利用規約作成
- [ ] リリースノート作成

## 依存関係

### 主要パッケージ
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 状態管理
  flutter_riverpod: ^2.4.0
  
  # Firebase
  firebase_core: ^2.15.0
  firebase_auth: ^4.7.2
  cloud_firestore: ^4.8.4
  firebase_storage: ^11.2.5
  firebase_analytics: ^10.4.5
  cloud_functions: ^4.3.3
  
  # UI/UX
  cupertino_icons: ^1.0.8
  material_color_utilities: ^0.5.0
  
  # ローカルストレージ
  shared_preferences: ^2.2.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # HTTP通信
  dio: ^5.3.0
  
  # 日時処理
  intl: ^0.18.1
  timezone: ^0.9.2
  
  # カレンダー連携
  google_sign_in: ^6.1.4
  googleapis: ^11.4.0
  device_calendar: ^4.3.1
  
  # 通知
  flutter_local_notifications: ^15.1.0+1
  
  # AI/ML
  tflite_flutter: ^0.10.4
  
  # その他ユーティリティ
  uuid: ^3.0.7
  path_provider: ^2.1.0
  permission_handler: ^10.4.3
```

### 開発用パッケージ
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # テスト
  mockito: ^5.4.2
  build_runner: ^2.4.6
  
  # コード品質
  flutter_lints: ^3.0.0
  very_good_analysis: ^5.1.0
  
  # Hive code generation
  hive_generator: ^2.0.0
```

## Getting Started

### 1. 環境設定
```bash
# Flutter SDKのインストール確認
flutter doctor

# プロジェクトの依存関係インストール
flutter pub get

# Hiveアダプター生成
flutter packages pub run build_runner build
```

### 2. Firebase設定
```bash
# Firebase CLIインストール
npm install -g firebase-tools

# Firebaseプロジェクト初期化
firebase login
firebase init

# FlutterFire CLI設定
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. 開発サーバー起動
```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android

# Web
flutter run -d web
```

### 4. テスト実行
```bash
# 全テスト実行
flutter test

# カバレッジ付きテスト
flutter test --coverage
```

### 5. ビルド
```bash
# Android APK
flutter build apk --release

# iOS IPA (要Xcode設定)
flutter build ios --release

# Web
flutter build web --release
```

## コントリビューション

1. Issueの確認・作成
2. フィーチャーブランチの作成
3. コード実装（Lintルールに従う）
4. テストの追加・実行
5. プルリクエストの作成

## ライセンス

This project is licensed under the MIT License.
