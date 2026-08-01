// import '../../../core.dart';
//
// class EncryptionInterceptor extends Interceptor {
//   final ApiEncryptionService encryption;
//   final AppConfigService config;
//
//   EncryptionInterceptor(this.encryption, this.config);
//
//   String toCurl(RequestOptions options) {
//     final buffer = StringBuffer();
//
//     buffer.write('curl -X ${options.method} \\\n');
//
//     // Headers
//     options.headers.forEach((key, value) {
//       if (value != null) {
//         buffer.write('  -H "$key: $value" \\\n');
//       }
//     });
//
//     // Body
//     if (options.data != null) {
//       final data = options.data is String ? options.data : jsonEncode(options.data);
//
//       buffer.write("  --data '${data.replaceAll("'", r"\'")}' \\\n");
//     }
//
//     // URL (with query params)
//     buffer.write('  "${options.uri}"');
//
//     return buffer.toString();
//   }
//
//   static bool isEncryptionEnabled = false;
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     final secret = options.headers['X-App-Secret'];
//
//     if (secret != null && options.path != ApiUrl.appVersion) {
//       final secureStorageService = sl<SecureStorageService>();
//       isEncryptionEnabled = await secureStorageService.read<bool>(Flags.encryptionEnabled) ?? false;
//       options.headers['X-App-Secret'] = encryption.encryptHeader(secret);
//     } else {
//       debugPrint("App Secret is not present");
//     }
//
//     debugPrint("Encryption Enabled: ${AppConfigService.isEncryptionEnabled}");
//
//     if (options.data != null && isEncryptionEnabled) {
//       options.data = encryption.encryptPayload(jsonEncode(options.data));
//     }
//
//     handler.next(options);
//   }
// }
