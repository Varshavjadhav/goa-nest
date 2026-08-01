import 'package:dartz/dartz.dart';

abstract class EntityConvertible<E> {
  E toEntity();
}

extension NullableX<T> on T? {
  T or(T defaultValue) => this ?? defaultValue;
}

extension NullableListX<T> on List<T>? {
  List<T> orEmpty() => this ?? const [];
}

extension EitherX<L, R> on Either<L, R> {
  Either<L, T> mapRight<T>(T Function(R r) mapper) {
    return fold((l) => Left(l), (r) => Right(mapper(r)));
  }
}
