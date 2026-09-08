import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/data/network/response/base_response_model.dart';
import 'package:goanest/core/data/network/service/base_api_service.dart';
import 'package:goanest/features/login/data/model/login_model.dart';
import 'package:goanest/resources/constants/url_end_points.dart';

class LoginRemoteDataSource {
  final BaseApiServices apiService;

  const LoginRemoteDataSource(this.apiService);

  Future<Either<AppException, BaseResponseModel<LoginResponse>>> login({
    required String email,
    required String password,
  }) {
    return apiService.postApi<LoginResponse>(
      ApiUrl.login,
      const {},
      LoginResponse.fromJson,
      body: {'email': email, 'password': password},
      disableTokenValidityCheck: true,
    );
  }
}
