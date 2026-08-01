import '../../../core.dart';
import 'app_exception.dart';
import 'error_model.dart';

class Failure {
  /// Maps DioException → AppException
  static AppException handleDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutError();

      case DioExceptionType.badCertificate:
        return const HandshakeError();

      case DioExceptionType.cancel:
        return const RequestCancelledError();

      case DioExceptionType.connectionError:
        return const NoInternetError();

      case DioExceptionType.badResponse:
        return _handleBadResponseError(dioException);

      case DioExceptionType.unknown:
        final error = dioException.error;
        if (error is SocketException) {
          return const NoInternetError();
        }
        if (error is HandshakeException) {
          return const HandshakeError();
        }
        return const UnknownError();
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  /// Handles non-2xx HTTP responses
  static AppException _handleBadResponseError(DioException dioException) {
    final response = dioException.response;

    if (response == null) {
      return const UnknownError();
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    final String message = _extractMessage(data, fallback: response.statusMessage, statusCode: statusCode);

    switch (statusCode) {
      case 400:
        return const BadRequestError();

      case 401:
        return const SessionExpiry();

      case 403:
        return const ForbiddenError();

      case 404:
        return const NotFoundError();

      case 405:
        return const MethodNotAllowedError();

      case 409:
        return ConflictError();

      case 422:
        return ValidationError(message: message, fieldErrors: {});

      case 429:
        return const TooManyRequestsError();

      case 499:
        if (data is Map<String, dynamic>) {
          return EncryptionPayloadError(error: ErrorModel.fromJson(data['error']));
        }
        return const UnknownError();

      case 500:
        return ServerError(statusCode: 500);

      case 502:
        return BadGatewayError();

      case 503:
        return const ServiceUnavailableError();

      case 504:
        return const GatewayTimeoutError();

      case 505:
        return const HTTPVersionNotSupportedError();

      default:
        return UnknownError();
    }
  }

  /// Safely extracts message from API response
  static String _extractMessage(dynamic data, {String? fallback, int? statusCode}) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    if (fallback != null && fallback.isNotEmpty) {
      return '$fallback${statusCode != null ? ' [$statusCode]' : ''}';
    }

    return 'Something went wrong';
  }
}
