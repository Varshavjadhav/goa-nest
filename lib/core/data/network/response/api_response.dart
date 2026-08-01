import '../../../../utilities/enums/enums_types.dart';
import '../../error/app_exception.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;
  AppException? exception;

  ApiResponse(this.status, this.data, this.exception, this.message);

  ApiResponse.initial() : status = Status.initial;

  ApiResponse.loading() : status = Status.loading;

  ApiResponse.completed(this.data) : status = Status.completed;

  ApiResponse.error(this.exception) : status = Status.error;

  ApiResponse.setResponse(ApiResponse<T> response) {
    status = response.status;
    message = response.message;
    data = response.data;
    exception = response.exception;
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    return ApiResponse<T>(
      _statusFromString(json['status'] as String?),
      json['data'] == null ? null : fromJsonT(json['data']),
      null,
      json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return {
      'status': status?.toString(),
      'data': data == null ? null : toJsonT(data as T),
      'message': message,
      // exception: serialize if needed
    };
  }

  static Status _statusFromString(String? statusString) {
    // convert string to Status enum - customize this
    switch (statusString) {
      case 'Status.initial':
        return Status.initial;
      case 'Status.loading':
        return Status.loading;
      case 'Status.completed':
        return Status.completed;
      case 'Status.error':
        return Status.error;
      default:
        return Status.initial;
    }
  }

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data: $data \n Exception: $exception";
  }
}
