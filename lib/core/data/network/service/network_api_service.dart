import 'package:dartz/dartz.dart';

import '/core.dart';
import '../../../../resources/constants/constants.dart';
import '../../../../resources/constants/url_end_points.dart';
import '../../../di/injector.dart';
import '../../../services/local_secure_storage/secure_storage_service.dart';
import '../../error/app_exception.dart';
import '../../error/failure.dart';
import '../../interceptors/auth_interceptor.dart';
import '../../interceptors/network_interceptor.dart';
import '../response/base_response_model.dart';
import '../response/parser.dart';
import 'base_api_service.dart';

class NetworkApiService extends BaseApiServices {
  late final Dio _dio;

  NetworkApiService() {
    final baseOptions = BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: Duration(seconds: 60),
      sendTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
      responseType: ResponseType.json,
      headers: Constants.baseHeader,
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
    );

    _dio = Dio(baseOptions);

    _dio.interceptors.addAll([
      NetworkInterceptor(),
      AuthInterceptor(sl<SecureStorageService>()),
    ]);
  }

  @override
  Future<Either<AppException, BaseResponseModel<T>>> getApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      if (queryParams != null && queryParams.isNotEmpty) {
        apiURL = "$apiURL${Uri(queryParameters: queryParams)}";
      }

      final response = await _dio.get(apiURL);

      return await Parser.parseBaseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return Left(Failure.handleDioError(e));
    }
  }

  @override
  Future<Either<AppException, BaseResponseModel<T>>> postApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    body,
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      if (queryParams != null && queryParams.isNotEmpty) {
        apiURL = "$apiURL${Uri(queryParameters: queryParams)}";
      }

      final response = await _dio.post(apiURL, data: body);

      return await Parser.parseBaseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return Left(Failure.handleDioError(e));
    }
  }

  @override
  Future<Either<AppException, BaseResponseModel<T>>> putApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    body,
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      if (queryParams != null && queryParams.isNotEmpty) {
        apiURL = "$apiURL${Uri(queryParameters: queryParams)}";
      }

      final response = await _dio.put(apiURL, data: body);

      return await Parser.parseBaseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return Left(Failure.handleDioError(e));
    }
  }

  @override
  Future<Either<AppException, BaseResponseModel<T>>> patchApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    body,
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      if (queryParams != null && queryParams.isNotEmpty) {
        apiURL = "$apiURL${Uri(queryParameters: queryParams)}";
      }

      final response = await _dio.patch(apiURL, data: body);

      return await Parser.parseBaseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return Left(Failure.handleDioError(e));
    }
  }

  @override
  Future<Either<AppException, BaseResponseModel<T>>> deleteApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    body,
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      if (queryParams != null && queryParams.isNotEmpty) {
        apiURL = "$apiURL${Uri(queryParameters: queryParams)}";
      }

      final response = await _dio.delete(apiURL, data: body);

      return await Parser.parseBaseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return Left(Failure.handleDioError(e));
    }
  }

  @override
  Future<Either<AppException, BaseResponseModel<T>>> multipartApi<T>(
    String apiURL,
    Map<String, String> headers,
    T Function(Map<String, dynamic>) fromJson, {
    body,
    required List<String> path,
    required String fileFieldName,
    bool disableTokenValidityCheck = false,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      if (queryParams != null && queryParams.isNotEmpty) {
        apiURL = "$apiURL${Uri(queryParameters: queryParams)}";
      }

      final formData = FormData();

      for (final filePath in path) {
        final fileName = filePath.split('/').last;
        final extension = fileName.split('.').last.toLowerCase();

        final mimeType = extension == 'pdf' ? 'application/pdf' : 'image/$extension';

        formData.files.add(
          MapEntry(fileFieldName, await MultipartFile.fromFile(filePath, filename: fileName, contentType: DioMediaType.parse(mimeType))),
        );
      }

      if (body != null) {
        body.forEach((key, value) {
          if (value != null) {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });
      }

      final response = await _dio.post(
        apiURL,
        data: formData,
        options: Options(headers: headers),
      );

      return await Parser.parseBaseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return Left(Failure.handleDioError(e));
    }
  }

  @override
  Future<Either<AppException, Uint8List>> downloadPdfBytes(String apiURL, Map<String, String> headers, {String? fileName}) async {
    try {
      final Uri uri = Uri.parse("$storageUrl$apiURL");

      String cleanFileName = (fileName ?? uri.pathSegments.last)
          .replaceAll(RegExp(r'\.pdf$'), '')
          .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

      final cacheDir = await getTemporaryDirectory();
      final String pdfFileName = "$cleanFileName.pdf";
      final filePath = "${cacheDir.path}/$pdfFileName";
      final file = File(filePath);

      if (await file.exists()) {
        debugPrint("PDF loaded from cache: $filePath");
        final bytes = await file.readAsBytes();
        return Right(bytes);
      }

      final response = await _dio.get<List<int>>(
        uri.toString(),
        options: Options(responseType: ResponseType.bytes, headers: headers),
      );

      if (response.data == null) {
        return Left(UnknownError());
      }

      final Uint8List pdfBytes = Uint8List.fromList(response.data!);

      await file.writeAsBytes(pdfBytes, flush: true);

      debugPrint("PDF downloaded & cached at: $filePath");

      return Right(pdfBytes);
    } catch (e, st) {
      debugPrint("Download PDF error: $e\n$st");
      return Left(UnknownError());
    }
  }
}
