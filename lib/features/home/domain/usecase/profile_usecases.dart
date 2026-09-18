import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import '../../data/model/profile_model.dart';
import '../repository/home_repository.dart';

class GetProfileUseCase {
  final HomeRepository repository;
  const GetProfileUseCase(this.repository);

  Future<Either<AppException, ProfileModel>> call() => repository.getProfile();
}

class UpdateProfileUseCase {
  final HomeRepository repository;
  const UpdateProfileUseCase(this.repository);

  Future<Either<AppException, ProfileModel>> call(ProfileUpdateRequest request) =>
      repository.updateProfile(request);
}
