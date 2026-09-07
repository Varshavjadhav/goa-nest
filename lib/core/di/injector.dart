import '../../core.dart';
import '../data/network/service/base_api_service.dart';
import '../data/network/service/network_api_service.dart';
import '../services/local_secure_storage/secure_storage_service.dart';
import '../services/local_secure_storage/secure_storage_service_impl.dart';
import '../../features/login/data/datasource/register_remote_datasource.dart';
import '../../features/login/data/repository/register_repository_impl.dart';
import '../../features/login/domain/usecase/register_user.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  if (sl.isRegistered<Dio>()) return;

  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(),
  );
  sl.registerLazySingleton<BaseApiServices>(() => NetworkApiService());
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSource(sl<BaseApiServices>()),
  );
  sl.registerLazySingleton<RegisterRepositoryImpl>(
    () => RegisterRepositoryImpl(
      sl<RegisterRemoteDataSource>(),
      sl<SecureStorageService>(),
    ),
  );
  sl.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(sl<RegisterRepositoryImpl>()),
  );
}
