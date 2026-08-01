import '../../error/app_exception.dart';

typedef ErrorStateUpdater<T> = T Function(AppException error);

mixin ErrorHandlingMixin {
  void handleError<T>(
    // Ref ref,
    AppException error,
    T? currentState,
    ErrorStateUpdater<T>? onStateError, {
    void Function(String message)? onInline,
    bool isInitApi = false,
  }) {
    if (isInitApi ||
        error is UnauthorizedError ||
        error is SessionExpiry ||
        error is ForbiddenError ||
        error is ServerError ||
        error is NoInternetError ||
        error is TimeoutError ||
        error is HandshakeError ||
        error is EncryptionPayloadError) {
      // ref.read(fatalErrorProvider.notifier).state = error;
    } else if (error is RequestCancelledError) {
      // ref.read(fatalErrorProvider.notifier).state = null;
    } else if (currentState != null && onStateError != null) {
      onStateError(error);
      onInline?.call(error.message);
      return;
    } else {
      onInline?.call(error.message);
    }
  }
}
