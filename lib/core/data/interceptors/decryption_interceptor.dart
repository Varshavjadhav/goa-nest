// import '../../../core.dart';
// import '../../../resources/constants/flags.dart';
// import '../../di/injector.dart';
// import '../../services/local_secure_storage/secure_storage_service.dart';
// import '../network/encryption/api_encryption_service.dart';
// import '../network/service/app_config_service.dart';
//
// class DecryptionInterceptor extends Interceptor {
//   final ApiEncryptionService encryption;
//   final AppConfigService config;
//
//   DecryptionInterceptor(this.encryption, this.config);
//
//   static bool isEncryptionEnabled = false;
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) async {
//     final secureStorageService = sl<SecureStorageService>();
//     isEncryptionEnabled = await secureStorageService.read<bool>(Flags.encryptionEnabled) ?? false;
//     if (!isEncryptionEnabled) {
//       return handler.next(response);
//     }
//
//     if (response.statusCode == 200 && response.data is String && (response.data as String).isNotEmpty) {
//       response.data = encryption.decryptResponse(response.data);
//     }
//
//     handler.next(response);
//   }
// }
