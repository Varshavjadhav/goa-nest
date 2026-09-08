import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/features/login/data/model/login_model.dart';

abstract class LoginRepository {
  Future<Either<AppException, LoginResponse>> login({
    required String email,
    required String password,
  });
}
