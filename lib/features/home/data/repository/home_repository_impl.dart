import '../../domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/data/network/response/base_response_model.dart';
import '../datasource/home_remote_datasource.dart';
import '../model/explore_model.dart';
import '../model/property_detail_model.dart';
import '../model/home_model.dart';
import '../model/wishlist_model.dart';
import '../model/favorite_model.dart';
import '../model/search_model.dart';
import '../model/profile_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<AppException, ExploreModel>> getExplore() =>
      remoteDataSource.getExplore().mapEntity((data) => data);

  @override
  Future<Either<AppException, ProfileModel>> getProfile() =>
      remoteDataSource.getProfile().mapEntity((data) => data);

  @override
  Future<Either<AppException, ProfileModel>> updateProfile(
    ProfileUpdateRequest request,
  ) => remoteDataSource.updateProfile(request).mapEntity((data) => data);

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
  Future<Either<AppException, SearchResultsModel>> search(SearchQuery query) =>
      remoteDataSource.search(query).mapEntity((data) => data);

  @override
  Future<Either<AppException, List<SearchSuggestionModel>>>
  getSearchSuggestions(String query) =>
      remoteDataSource.getSearchSuggestions(query).mapEntity((data) => data);

  @override
  Future<Either<AppException, List<WishlistModel>>> getWishlists() =>
      remoteDataSource.getWishlists().mapEntity((data) => data);

  @override
  Future<Either<AppException, WishlistModel>> createWishlist(String name) =>
      remoteDataSource.createWishlist(name).mapEntity((data) => data);

  @override
  Future<Either<AppException, WishlistModel>> addPropertyToWishlist(
    String wishlistId,
    String propertyId,
  ) => remoteDataSource
      .addPropertyToWishlist(wishlistId, propertyId)
      .mapEntity((data) => data);

  @override
  Future<Either<AppException, WishlistModel>> removePropertyFromWishlist(
    String wishlistId,
    String propertyId,
  ) => remoteDataSource
      .removePropertyFromWishlist(wishlistId, propertyId)
      .mapEntity((data) => data);

  @override
  Future<Either<AppException, FavoriteModel>> addFavorite(String id) =>
      remoteDataSource.addFavorite(id).mapEntity((data) => data);

  @override
  Future<Either<AppException, FavoriteModel>> removeFavorite(String id) =>
      remoteDataSource.removeFavorite(id).mapEntity((data) => data);

  @override
  Future<Either<AppException, ResultMessage>> markRecentlyViewed(String id) =>
      remoteDataSource.markRecentlyViewed(id).mapMessage();
}
