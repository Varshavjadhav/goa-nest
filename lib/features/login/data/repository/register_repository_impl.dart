import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/services/local_secure_storage/secure_storage_service.dart';
import 'package:goanest/features/login/data/datasource/register_remote_datasource.dart';
import 'package:goanest/features/login/data/model/register_model.dart';
import 'package:goanest/features/login/domain/repository/register_repository.dart';
import 'package:goanest/resources/constants/flags.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;
  final SecureStorageService storage;

  const RegisterRepositoryImpl(this.remoteDataSource, this.storage);

  @override
  Future<Either<AppException, RegisterResponse>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );
    if (result.isLeft()) {
      return Left(
        result.fold(
          (error) => error,
          (_) => throw StateError('Unexpected registration result'),
        ),
      );
    }
    final response = result.getOrElse(
      () => throw StateError('Missing registration response'),
    );
    final data = response.data;
    if (data == null) return Left(UnknownError());
    await storage.write(Flags.token, data.accessToken);
    await storage.write(Flags.refreshToken, data.refreshToken);
    return Right(data);
  }
}
