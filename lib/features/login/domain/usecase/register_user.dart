import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/features/login/data/model/register_model.dart';
import 'package:goanest/features/login/domain/repository/register_repository.dart';

class RegisterUserUseCase {
  final RegisterRepository repository;

  const RegisterUserUseCase(this.repository);

  Future<Either<AppException, RegisterResponse>> call({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) => repository.register(
    name: name,
    email: email,
    phone: phone,
    password: password,
  );
}
