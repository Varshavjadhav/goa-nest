import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/data/network/response/base_response_model.dart';
import '../../data/model/home_model.dart';
import '../../data/model/property_detail_model.dart';
import '../../data/model/wishlist_model.dart';

abstract class HomeRepository {
  Future<Either<AppException, HomeModel>> getHome();
  Future<Either<AppException, PropertyDetailModel>> getProperty(String id);
  Future<Either<AppException, PropertyCollection>> getRecentlyViewed({
    int page = 1,
    int limit = 20,
  });
  Future<Either<AppException, List<WishlistModel>>> getWishlists();
  Future<Either<AppException, ResultMessage>> addFavorite(String id);
  Future<Either<AppException, ResultMessage>> removeFavorite(String id);
  Future<Either<AppException, ResultMessage>> markRecentlyViewed(String id);
}
