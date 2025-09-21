import 'package:task_aiagent/core/error/failures.dart' as core;

abstract class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  T get value {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    throw Exception('Called value on Failure');
  }

  core.Failure get failure {
    if (this is ResultFailure<T>) {
      return (this as ResultFailure<T>).failure;
    }
    throw Exception('Called failure on Success');
  }

  R fold<R>(R Function(core.Failure failure) onFailure, R Function(T value) onSuccess) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    } else {
      return onFailure((this as ResultFailure<T>).failure);
    }
  }
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class ResultFailure<T> extends Result<T> {
  final core.Failure failure;
  const ResultFailure(this.failure);
}

// 便利なtypedef
typedef AsyncResult<T> = Future<Result<T>>;