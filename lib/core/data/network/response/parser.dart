import 'package:dartz/dartz.dart';

import '../../../../core.dart';
import '../../error/app_exception.dart';
import 'base_response_model.dart';

class Parser {
  static Future<Either<AppException, BaseResponseModel<T>>> parseBaseResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      if (response.statusCode != HttpStatus.ok && response.statusCode != HttpStatus.created) {
        return Left(UnknownError());
      }

      final Map<String, dynamic> json = Map<String, dynamic>.from(response.data);

      final bool status = json['status'] == true || json['success'] == true;
      final String message = json['message']?.toString() ?? '';

      if (!status) {
        return Left(ValidationError(message: message, fieldErrors: {}));
      }

      final rawData = json['data'];

      if (rawData == null) {
        return Right(BaseResponseModel<T>(status: true, message: message, data: null));
      }

      final T parsedData = await compute(_computeParser(fromJson), jsonEncode(rawData));

      return Right(BaseResponseModel<T>(status: true, message: message, data: parsedData));
    } catch (e, st) {
      debugPrintStack(stackTrace: st, label: e.toString());
      return Left(UnknownError());
    }
  }

  static ComputeCallback<String, T> _computeParser<T>(T Function(Map<String, dynamic>) fromJson) {
    return (String jsonString) {
      final dynamic decoded = json.decode(jsonString);

      if (decoded is List) {
        return decoded.map((e) => fromJson(Map<String, dynamic>.from(e as Map))).toList() as T;
      }

      if (decoded is Map<String, dynamic>) {
        return fromJson(decoded);
      }

      return null as T;
    };
  }
}
