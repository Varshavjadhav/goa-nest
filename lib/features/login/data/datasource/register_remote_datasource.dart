import 'package:goanest/core/data/network/service/base_api_service.dart';
import 'package:goanest/core/data/network/response/base_response_model.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/features/login/data/model/register_model.dart';
import 'package:goanest/resources/constants/url_end_points.dart';
import 'package:dartz/dartz.dart';

class RegisterRemoteDataSource {
  final BaseApiServices apiService;

  const RegisterRemoteDataSource(this.apiService);

  Future<Either<AppException, BaseResponseModel<RegisterResponse>>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    return apiService.postApi<RegisterResponse>(
      ApiUrl.register,
      const {},
      RegisterResponse.fromJson,
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
      disableTokenValidityCheck: true,
    );
  }
}
