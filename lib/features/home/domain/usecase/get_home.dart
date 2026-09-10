import '../repository/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import '../../data/model/home_model.dart';

class GetHomeUseCase {
  final HomeRepository repository;

  const GetHomeUseCase(this.repository);

  Future<Either<AppException, HomeModel>> call() => repository.getHome();
}
