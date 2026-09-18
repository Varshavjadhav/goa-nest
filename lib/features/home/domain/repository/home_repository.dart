import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/data/network/response/base_response_model.dart';
import '../../data/model/explore_model.dart';
import '../../data/model/home_model.dart';
import '../../data/model/property_detail_model.dart';
import '../../data/model/wishlist_model.dart';
import '../../data/model/favorite_model.dart';
import '../../data/model/search_model.dart';
import '../../data/model/profile_model.dart';

abstract class HomeRepository {
  Future<Either<AppException, ExploreModel>> getExplore();
  Future<Either<AppException, ProfileModel>> getProfile();
  Future<Either<AppException, ProfileModel>> updateProfile(
    ProfileUpdateRequest request,
  );
  Future<Either<AppException, PropertyDetailModel>> getProperty(String id);
  Future<Either<AppException, PropertyCollection>> getRecentlyViewed({
    int page = 1,
    int limit = 20,
  });
  Future<Either<AppException, SearchResultsModel>> search(SearchQuery query);
  Future<Either<AppException, List<SearchSuggestionModel>>>
  getSearchSuggestions(String query);
  Future<Either<AppException, List<WishlistModel>>> getWishlists();
  Future<Either<AppException, WishlistModel>> createWishlist(String name);
  Future<Either<AppException, WishlistModel>> addPropertyToWishlist(
    String wishlistId,
    String propertyId,
  );
  Future<Either<AppException, WishlistModel>> removePropertyFromWishlist(
    String wishlistId,
    String propertyId,
  );
  Future<Either<AppException, FavoriteModel>> addFavorite(String id);
  Future<Either<AppException, FavoriteModel>> removeFavorite(String id);
  Future<Either<AppException, ResultMessage>> markRecentlyViewed(String id);
}
