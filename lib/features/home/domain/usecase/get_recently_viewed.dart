import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import '../../data/model/home_model.dart';
import '../repository/home_repository.dart';

class GetRecentlyViewedUseCase {
  final HomeRepository repository;
  const GetRecentlyViewedUseCase(this.repository);

  Future<Either<AppException, PropertyCollection>> call({
    int page = 1,
    int limit = 20,
  }) => repository.getRecentlyViewed(page: page, limit: limit);
}
