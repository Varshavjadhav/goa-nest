

import '../../../core.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.first == ConnectivityResult.none) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'No internet connection !!!',
          type: DioExceptionType.connectionError,
        ),
      );
    }
    return handler.next(options);
  }
}
