import '../../../core.dart';
import '../../../resources/constants/constants.dart';
import '../../../resources/constants/flags.dart';
import '../../di/injector.dart';
import '../../services/local_secure_storage/secure_storage_service.dart';

class AppHeaderInterceptor extends Interceptor {
  // final AppConfigService config;
  // AppHeaderInterceptor(this.config);
  AppHeaderInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final storage = sl<SecureStorageService>();

    final storedLanguage = await storage.read<String>(Flags.language);

    // final languageCode = storedLanguage != null
    //     ? Language.values.byName(storedLanguage).locale.languageCode
    //     : WidgetsBinding.instance.platformDispatcher.locale.languageCode;

    // final deviceInfo = sl<AppDeviceInfoService>().appDeviceInfoModel;

    options.headers.addAll({
      ...Constants.baseHeader,
      // 'User-Agent': deviceInfo.userAgent,
      // 'Accept-Language': languageCode,
      // 'X-Package-Name': F.packageName,
      // 'X-Os-Version': deviceInfo.osVersion,
      // 'X-Platform' : 'bypass',
      'X-Platform': Platform.isIOS ? 'iOS' : 'Android',
      // 'X-App-Secret': Env.headerPlainText,
      // 'X-App-Version': deviceInfo.appVersion,
      // 'is_encryption': true,
    });

    handler.next(options);
  }
}
