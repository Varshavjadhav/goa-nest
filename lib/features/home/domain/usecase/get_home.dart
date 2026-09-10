import '../repository/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import '../../data/model/explore_model.dart';

class GetHomeUseCase {
  final HomeRepository repository;

  const GetHomeUseCase(this.repository);

  Future<Either<AppException, ExploreModel>> call() => repository.getExplore();
}
