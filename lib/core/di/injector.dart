import '../../core.dart';
import '../data/network/service/base_api_service.dart';
import '../data/network/service/network_api_service.dart';
import '../services/local_secure_storage/secure_storage_service.dart';
import '../services/local_secure_storage/secure_storage_service_impl.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Register the singleton instance
  if (sl.isRegistered<Dio>()) return;

  sl.registerLazySingleton<Dio>(() => Dio());
  // sl.registerLazySingleton<ApiEncryptionService>(
  //   () => AesEncryptionService(
  //     headerKey: Env.headerEncryptionKey,
  //     payloadKey: Env.payloadEncryptionKey,
  //   ),
  // );
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageServiceImpl());
  // sl.registerLazySingleton<AppConfigService>(() => AppConfigService());
  sl.registerLazySingleton<BaseApiServices>(() => NetworkApiService());
  // sl.registerLazySingleton<AppDeviceInfoService>(() => AppDeviceInfoService());
  // sl.registerLazySingleton<SafeDeviceService>(() => SafeDeviceService());
  // sl.registerLazySingleton<PhonePePaymentService>(
  //   () => PhonePePaymentServiceImpl(),
  // );
  // sl.registerLazySingleton<SplashRepository>(() => SplashRepositoryImpl(sl<BaseApiServices>()));
  // sl.registerLazySingleton<PhonepeAutopayRepository>(
  //   () => PhonepeAutopayRepositoryImpl(),
  // );
}
