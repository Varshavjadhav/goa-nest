import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/features/login/data/model/register_model.dart';

abstract class RegisterRepository {
  Future<Either<AppException, RegisterResponse>> register({
    required String name,
    required String email,
    required String password,
  });
}
