import 'package:dartz/dartz.dart';

import '/core.dart';
import '../../error/app_exception.dart';
import '../response/base_response_model.dart';

abstract class BaseApiServices {
  Future<Either<AppException, BaseResponseModel<T>>> postApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    body,
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  });

  Future<Either<AppException, BaseResponseModel<T>>> getApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  });

  Future<Either<AppException, BaseResponseModel<T>>> multipartApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    body,
    required List<String> path,
    required String fileFieldName,
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  });

  Future<Either<AppException, BaseResponseModel<T>>> putApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    body,
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  });

  Future<Either<AppException, BaseResponseModel<T>>> patchApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    body,
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  });

  Future<Either<AppException, BaseResponseModel<T>>> deleteApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    body,
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  });

  Future<Either<AppException, Uint8List>> downloadPdfBytes(String apiURL, Map<String, String> headers, {String? fileName});
}
