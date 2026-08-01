import 'package:dartz/dartz.dart';

import '../../../../core.dart';
import '../../error/app_exception.dart';

part 'base_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponseModel<T> {
  final bool status;
  final String message;
  final T? data;

  BaseResponseModel({required this.status, required this.message, this.data});

  factory BaseResponseModel.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseResponseModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$BaseResponseModelToJson(this, toJsonT);
}

extension BaseResponseEitherX<T> on Either<AppException, BaseResponseModel<T>> {
  Either<AppException, T> unwrap() {
    return fold((l) => Left(l), (r) => Right(r.data as T));
  }
}

extension ApiFutureEitherX<T> on Future<Either<AppException, BaseResponseModel<T>>> {
  Future<Either<AppException, R>> mapEntity<R>(R Function(T data) mapper) {
    return then(
      (either) => either.fold(Left.new, (response) {
        final data = response.data;
        if (data == null) {
          return Left(UnknownError());
        }
        return Right(mapper(data));
      }),
    );
  }
}

extension ListMapper<D> on List<D> {
  List<E> mapToEntity<E>(E Function(D dto) mapper) {
    return map<E>(mapper).toList();
  }
}

extension ApiFutureEitherMessageX on Future<Either<AppException, BaseResponseModel<dynamic>>> {
  Future<Either<AppException, ResultMessage>> mapMessage() {
    return then((either) => either.fold(Left.new, (response) => Right(ResultMessage(response.message))));
  }
}

// extension ApiFutureEitherMessageX on Future<Either<AppException, BaseResponseModel<dynamic>>> {
//   Future<Either<AppException, ResultMessage>> mapMessage() {
//     return then((either) => either.fold(Left.new, (response) => Right(ResultMessage(response.message))));
//   }
// }
// extension ApiFutureEitherMessageX on Future<Either<AppException, BaseResponseModel<dynamic>>> mapMessage() {
//   return then((either) => either.fold(Left.new, (response) => Right(ResultMessage(response.message ?? 'Success'))));
// }

class ResultMessage {
  final String message;

  const ResultMessage(this.message);
}

class GlobalError {
  final String message;

  const GlobalError(this.message);
}

class GlobalSuccess {
  final String message;

  const GlobalSuccess(this.message);
}
