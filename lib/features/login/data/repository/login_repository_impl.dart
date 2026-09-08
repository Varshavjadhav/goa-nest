import '../../domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/services/local_secure_storage/secure_storage_service.dart';
import 'package:goanest/features/login/data/datasource/login_remote_datasource.dart';
import 'package:goanest/features/login/data/model/login_model.dart';
import 'package:goanest/resources/constants/flags.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final SecureStorageService storage;

  const LoginRepositoryImpl(this.remoteDataSource, this.storage);

  @override
  Future<Either<AppException, LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.login(
      email: email,
      password: password,
    );

    return result.fold(Left.new, (response) async {
      final data = response.data;
      if (data == null ||
          data.accessToken.isEmpty ||
          data.refreshToken.isEmpty) {
        return Left(UnknownError());
      }

      await storage.write(Flags.token, data.accessToken);
      await storage.write(Flags.refreshToken, data.refreshToken);
      await storage.write(Flags.user, data.user);
      await storage.write(Flags.isLoggedIn, true);
      return Right(data);
    });
  }
}
