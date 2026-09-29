import '../../../app/router/route_name.dart';
import '../../../core.dart';
import '../../../utilities/global.dart';
import '../../../utilities/utils.dart';
import '../../../resources/constants/flags.dart';
import '../../services/local_secure_storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  static Future<void>? _sessionExpiryTask;

  final SecureStorageService storage;

  AuthInterceptor(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['skipAuth'] == true) {
      return handler.next(options);
    }

    final token = await storage.read<String>(Flags.token);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.extra['skipAuth'] != true) {
      try {
        await _expireSession();
      } catch (_) {
        // Continue returning the API error even if secure storage fails.
      }
    }
    handler.next(err);
  }

  Future<void> _expireSession() {
    final pending = _sessionExpiryTask;
    if (pending != null) return pending;

    final task = _clearSessionAndReturnToLogin();
    _sessionExpiryTask = task;
    return task.whenComplete(() {
      if (identical(_sessionExpiryTask, task)) _sessionExpiryTask = null;
    });
  }

  Future<void> _clearSessionAndReturnToLogin() async {
    for (final key in [Flags.token, Flags.refreshToken, Flags.user]) {
      try {
        await storage.delete(key);
      } catch (_) {
        // Still return to login if one secure-storage item cannot be removed.
      }
    }
    try {
      await storage.write(Flags.isLoggedIn, false);
    } catch (_) {
      // Navigation must not depend on the local flag being writable.
    }

    final context = Global.navigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    context.go(RouteName.loginView);
    Utils.showSnackBar(
      'Your session has expired. Please log in again.',
      result: Result.error,
    );
  }
}
