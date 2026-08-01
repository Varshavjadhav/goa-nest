import 'package:goanest/core/data/error/retry_callback.dart';

import '../../../utilities/enums/enums_types.dart';
import 'error_model.dart';

class AppException implements Exception {
  final String message;
  final int? code;
  final AppErrorCategory category;

  // UI helpers (only for actionable errors)
  final String? buttonText;
  final RetryCallback? retry;
  final ErrorActionType errorActionType;

  final ErrorModel? error;

  const AppException({
    required this.message,
    required this.category,
    this.code,
    this.buttonText,
    this.retry,
    this.errorActionType = ErrorActionType.none,
    this.error,
  });

  @override
  String toString() => 'AppException(category: $category, code: $code, message: $message)';
}

//─────────────────────────────────────────────
// Retryable Base
//─────────────────────────────────────────────
abstract class RetryableError extends AppException {
  const RetryableError({
    required super.message,
    required super.category,
    super.code,
    String super.buttonText = 'Try Again',
    RetryCallback? onRetry,
  }) : super(retry: onRetry, errorActionType: ErrorActionType.retry);

  RetryableError copyWith({RetryCallback? retry});
}

//─────────────────────────────────────────────
// Network / Client Errors
//─────────────────────────────────────────────

class NoInternetError extends RetryableError {
  const NoInternetError({super.onRetry}) : super(code: 503, message: 'No internet connection', category: AppErrorCategory.network);

  @override
  NoInternetError copyWith({RetryCallback? retry}) {
    return NoInternetError(onRetry: retry ?? this.retry);
  }
}

class TimeoutError extends RetryableError {
  const TimeoutError({super.onRetry}) : super(code: 504, message: 'The request timed out', category: AppErrorCategory.network);

  @override
  TimeoutError copyWith({RetryCallback? retry}) {
    return TimeoutError(onRetry: retry ?? this.retry);
  }
}

class HandshakeError extends RetryableError {
  const HandshakeError({super.onRetry}) : super(code: 526, message: 'SSL Handshake failed', category: AppErrorCategory.server);

  @override
  HandshakeError copyWith({RetryCallback? retry}) {
    return HandshakeError(onRetry: retry ?? this.retry);
  }
}

class RequestCancelledError extends RetryableError {
  const RequestCancelledError({super.onRetry}) : super(code: 499, message: 'Request cancelled', category: AppErrorCategory.network);

  @override
  RequestCancelledError copyWith({RetryCallback? retry}) {
    return RequestCancelledError(onRetry: retry ?? this.retry);
  }
}

class MethodNotAllowedError extends RetryableError {
  const MethodNotAllowedError({super.onRetry})
    : super(code: 405, message: 'Method Not Allowed: The HTTP method used is not supported.', category: AppErrorCategory.network);

  @override
  MethodNotAllowedError copyWith({RetryCallback? retry}) {
    return MethodNotAllowedError(onRetry: retry ?? this.retry);
  }
}

class TooManyRequestsError extends RetryableError {
  const TooManyRequestsError({super.onRetry})
    : super(code: 429, message: 'Too many requests. Please try again later.', category: AppErrorCategory.network);

  @override
  TooManyRequestsError copyWith({RetryCallback? retry}) {
    return TooManyRequestsError(onRetry: retry ?? this.retry);
  }
}

class BadGatewayError extends RetryableError {
  const BadGatewayError({super.onRetry})
    : super(code: 502, message: 'Bad Gateway: Invalid response from upstream server.', category: AppErrorCategory.network);

  @override
  BadGatewayError copyWith({RetryCallback? retry}) {
    return BadGatewayError(onRetry: retry ?? this.retry);
  }
}

class ServiceUnavailableError extends RetryableError {
  const ServiceUnavailableError({super.onRetry})
    : super(code: 503, message: 'Service temporarily unavailable.', category: AppErrorCategory.network);

  @override
  ServiceUnavailableError copyWith({RetryCallback? retry}) {
    return ServiceUnavailableError(onRetry: retry ?? this.retry);
  }
}

class GatewayTimeoutError extends RetryableError {
  const GatewayTimeoutError({super.onRetry}) : super(code: 504, message: 'Gateway timeout.', category: AppErrorCategory.network);

  @override
  GatewayTimeoutError copyWith({RetryCallback? retry}) {
    return GatewayTimeoutError(onRetry: retry ?? this.retry);
  }
}

class HTTPVersionNotSupportedError extends RetryableError {
  const HTTPVersionNotSupportedError({super.onRetry})
    : super(code: 505, message: 'HTTP version not supported.', category: AppErrorCategory.network);

  @override
  HTTPVersionNotSupportedError copyWith({RetryCallback? retry}) {
    return HTTPVersionNotSupportedError(onRetry: retry ?? this.retry);
  }
}

//─────────────────────────────────────────────
// Auth Errors
//─────────────────────────────────────────────

class SessionExpiry extends AppException {
  const SessionExpiry({RetryCallback? onLogin})
    : super(
        code: 401,
        message: 'Session has expired',
        buttonText: 'Login',
        retry: onLogin,
        errorActionType: ErrorActionType.logout,
        category: AppErrorCategory.auth,
      );
}

class UnauthorizedError extends AppException {
  const UnauthorizedError({String? message, RetryCallback? onLogin})
    : super(
        code: 401,
        message: message ?? 'Unauthorized access',
        buttonText: 'Login',
        retry: onLogin,
        errorActionType: ErrorActionType.logout,
        category: AppErrorCategory.auth,
      );
}

//─────────────────────────────────────────────
// Standard HTTP Errors
//─────────────────────────────────────────────

class ForbiddenError extends AppException {
  const ForbiddenError()
    : super(code: 403, message: 'You do not have permission to access this resource', category: AppErrorCategory.validation);
}

class NotFoundError extends RetryableError {
  const NotFoundError({super.onRetry}) : super(code: 404, message: 'Resource not found', category: AppErrorCategory.validation);

  @override
  NotFoundError copyWith({RetryCallback? retry}) {
    return NotFoundError(onRetry: retry ?? this.retry);
  }
}

class ServerError extends AppException {
  ServerError({int? statusCode})
    : super(
        message: "Server error, please try again later",
        code: statusCode,
        category: AppErrorCategory.server,
        buttonText: 'Retry',
        errorActionType: ErrorActionType.logout,
      );
}

class BadRequestError extends RetryableError {
  const BadRequestError({super.onRetry}) : super(code: 400, message: 'Bad request', category: AppErrorCategory.validation);

  @override
  BadRequestError copyWith({RetryCallback? retry}) {
    return BadRequestError(onRetry: retry ?? this.retry);
  }
}

class ConflictError extends RetryableError {
  const ConflictError({super.onRetry}) : super(code: 409, message: 'Conflict', category: AppErrorCategory.validation);

  @override
  ConflictError copyWith({RetryCallback? retry}) {
    return ConflictError(onRetry: retry ?? this.retry);
  }
}

//─────────────────────────────────────────────
// Validation / Business Errors
//─────────────────────────────────────────────

class ValidationError extends AppException {
  final Map<String, List<String>> fieldErrors;

  ValidationError({required this.fieldErrors, String? message, int? code})
    : super(message: message ?? 'Validation failed', code: code ?? 422, category: AppErrorCategory.validation);

  /// Helper
  String? firstError(String field) => fieldErrors[field]?.first;
}

class UnprocessableEntityError extends ValidationError {
  UnprocessableEntityError({required Map<String, List<String>> errors}) : super(fieldErrors: errors);
}

class UserExistsError extends ValidationError {
  UserExistsError()
    : super(
        fieldErrors: {
          'email': ['User already exists'],
        },
      );
}

//─────────────────────────────────────────────
// Misc
//─────────────────────────────────────────────

class InitialisationError extends RetryableError {
  const InitialisationError({super.onRetry}) : super(code: 496, message: 'Failed to initialise', category: AppErrorCategory.unknown);

  @override
  InitialisationError copyWith({RetryCallback? retry}) {
    return InitialisationError(onRetry: retry ?? this.retry);
  }
}

class PreconditionFailedError extends RetryableError {
  const PreconditionFailedError({super.onRetry}) : super(code: 412, message: 'Precondition failed', category: AppErrorCategory.unknown);

  @override
  PreconditionFailedError copyWith({RetryCallback? retry}) {
    return PreconditionFailedError(onRetry: retry ?? this.retry);
  }
}

class UnknownError extends RetryableError {
  const UnknownError({super.onRetry}) : super(code: 520, message: 'An unknown error occurred.', category: AppErrorCategory.unknown);

  @override
  UnknownError copyWith({RetryCallback? retry}) {
    return UnknownError(onRetry: retry ?? this.retry);
  }
}

class EncryptionPayloadError extends AppException {
  const EncryptionPayloadError({required ErrorModel error, RetryCallback? onRetry})
    : super(
        code: 499,
        message: 'Encryption payload error',
        error: error,
        buttonText: 'Retry',
        retry: onRetry,
        errorActionType: ErrorActionType.retry,
        category: AppErrorCategory.unknown,
      );
}
