import '../../core.dart';
import '../data/network/service/base_api_service.dart';
import '../data/network/service/network_api_service.dart';
import '../services/local_secure_storage/secure_storage_service.dart';
import '../services/local_secure_storage/secure_storage_service_impl.dart';
import '../../features/login/data/datasource/register_remote_datasource.dart';
import '../../features/login/data/datasource/login_remote_datasource.dart';
import '../../features/login/data/repository/login_repository_impl.dart';
import '../../features/login/data/repository/register_repository_impl.dart';
import '../../features/login/domain/usecase/get_login.dart';
import '../../features/login/domain/usecase/register_user.dart';
import '../../features/home/data/datasource/home_remote_datasource.dart';
import '../../features/home/data/repository/home_repository_impl.dart';
import '../../features/home/domain/usecase/get_home.dart';
import '../../features/home/domain/usecase/get_recently_viewed.dart';
import '../../features/home/domain/usecase/get_wishlists.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  if (sl.isRegistered<Dio>()) return;

  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(),
  );
  sl.registerLazySingleton<BaseApiServices>(() => NetworkApiService());
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSource(sl<BaseApiServices>()),
  );
  sl.registerLazySingleton<LoginRepositoryImpl>(
    () => LoginRepositoryImpl(
      sl<LoginRemoteDataSource>(),
      sl<SecureStorageService>(),
    ),
  );
  sl.registerLazySingleton<GetLoginUseCase>(
    () => GetLoginUseCase(sl<LoginRepositoryImpl>()),
  );
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
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(sl<BaseApiServices>()),
  );
  sl.registerLazySingleton<HomeRepositoryImpl>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetHomeUseCase>(
    () => GetHomeUseCase(sl<HomeRepositoryImpl>()),
  );
  sl.registerLazySingleton<GetRecentlyViewedUseCase>(
    () => GetRecentlyViewedUseCase(sl<HomeRepositoryImpl>()),
  );
  sl.registerLazySingleton<GetWishlistsUseCase>(
    () => GetWishlistsUseCase(sl<HomeRepositoryImpl>()),
  );
}
