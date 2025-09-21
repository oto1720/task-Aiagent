abstract class Failure {
  final String message;
  const Failure(this.message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'キャッシュエラーが発生しました']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'ネットワークエラーが発生しました']) : super(message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = '予期しないエラーが発生しました']) : super(message);
}