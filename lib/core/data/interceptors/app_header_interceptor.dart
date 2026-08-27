import '../../../core.dart';
import '../../../resources/constants/constants.dart';

class AppHeaderInterceptor extends Interceptor {
  AppHeaderInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({
      ...Constants.baseHeader,
      'X-Platform': Platform.isIOS ? 'iOS' : 'Android',
    });

    handler.next(options);
  }
}
