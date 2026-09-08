import '../repository/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/features/login/data/model/login_model.dart';

class GetLoginUseCase {
  final LoginRepository repository;

  const GetLoginUseCase(this.repository);

  Future<Either<AppException, LoginResponse>> call({
    required String email,
    required String password,
  }) => repository.login(email: email, password: password);
}
