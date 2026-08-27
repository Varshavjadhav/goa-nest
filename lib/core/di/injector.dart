import '../../core.dart';
import '../data/network/service/base_api_service.dart';
import '../data/network/service/network_api_service.dart';
import '../services/local_secure_storage/secure_storage_service.dart';
import '../services/local_secure_storage/secure_storage_service_impl.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  if (sl.isRegistered<Dio>()) return;

  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageServiceImpl());
  sl.registerLazySingleton<BaseApiServices>(() => NetworkApiService());
}
