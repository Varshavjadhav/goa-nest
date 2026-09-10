import '../../domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/data/network/response/base_response_model.dart';
import '../datasource/home_remote_datasource.dart';
import '../model/home_model.dart';
import '../model/property_detail_model.dart';
import '../model/wishlist_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<AppException, HomeModel>> getHome() =>
      remoteDataSource.getHome().mapEntity((data) => data);

  @override
  Future<Either<AppException, PropertyDetailModel>> getProperty(String id) =>
      remoteDataSource.getProperty(id).mapEntity((data) => data);

  @override
  Future<Either<AppException, PropertyCollection>> getRecentlyViewed({
    int page = 1,
    int limit = 20,
  }) => remoteDataSource
      .getRecentlyViewed(page: page, limit: limit)
      .mapEntity((data) => data);

  @override
  Future<Either<AppException, List<WishlistModel>>> getWishlists() =>
      remoteDataSource.getWishlists().mapEntity((data) => data);

  @override
  Future<Either<AppException, ResultMessage>> addFavorite(String id) =>
      remoteDataSource.addFavorite(id).mapMessage();

  @override
  Future<Either<AppException, ResultMessage>> removeFavorite(String id) =>
      remoteDataSource.removeFavorite(id).mapMessage();

  @override
  Future<Either<AppException, ResultMessage>> markRecentlyViewed(String id) =>
      remoteDataSource.markRecentlyViewed(id).mapMessage();
}
