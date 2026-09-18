import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/data/network/response/base_response_model.dart';
import 'package:goanest/core/data/network/service/base_api_service.dart';
import 'package:goanest/resources/constants/url_end_points.dart';

import '../model/explore_model.dart';
import '../model/favorite_model.dart';
import '../model/home_model.dart';
import '../model/property_detail_model.dart';
import '../model/wishlist_model.dart';
import '../model/search_model.dart';

class HomeRemoteDataSource {
  final BaseApiServices apiService;

  const HomeRemoteDataSource(this.apiService);

  Future<Either<AppException, BaseResponseModel<ExploreModel>>> getExplore() =>
      apiService.getApi(ApiUrl.home, const {}, ExploreModel.fromJson);

  Future<Either<AppException, BaseResponseModel<PropertyDetailModel>>>
  getProperty(String propertyId) => apiService.getApi(
    ApiUrl.propertyDetail.replaceAll('{propertyId}', propertyId),
    const {},
    PropertyDetailModel.fromJson,
  );

  Future<Either<AppException, BaseResponseModel<PropertyCollection>>>
  getRecentlyViewed({int page = 1, int limit = 20}) => apiService.getApi(
    ApiUrl.recentlyViewed,
    const {},
    PropertyCollection.fromJson,
    queryParams: {'page': page, 'limit': limit},
  );

  Future<Either<AppException, BaseResponseModel<SearchResultsModel>>> search(
    SearchQuery query,
  ) => apiService.getApi(
    ApiUrl.search,
    const {},
    SearchResultsModel.fromJson,
    queryParams: query.toQueryParams(),
  );

  Future<Either<AppException, BaseResponseModel<List<SearchSuggestionModel>>>>
  getSearchSuggestions(String query) => apiService.getApi(
    ApiUrl.searchSuggestions,
    const {},
    (json) => json['suggestions'] is List
        ? (json['suggestions'] as List)
              .whereType<Map>()
              .map(
                (item) => SearchSuggestionModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
        : const [],
    queryParams: {'q': query},
  );

  Future<Either<AppException, BaseResponseModel<List<WishlistModel>>>>
  getWishlists() => apiService.getApi(
    ApiUrl.wishlists,
    const {},
    (json) => _wishlistList(json['wishlists']),
  );

  Future<Either<AppException, BaseResponseModel<WishlistModel>>> createWishlist(
    String name,
  ) => apiService.postApi(
    ApiUrl.wishlists,
    const {},
    WishlistModel.fromResponseJson,
    body: {'name': name},
  );

  Future<Either<AppException, BaseResponseModel<WishlistModel>>>
  addPropertyToWishlist(String wishlistId, String propertyId) =>
      apiService.postApi(
        ApiUrl.wishlistProperties
            .replaceAll('{wishlistId}', wishlistId)
            .replaceAll('{propertyId}', propertyId),
        const {},
        WishlistModel.fromResponseJson,
      );

  Future<Either<AppException, BaseResponseModel<WishlistModel>>>
  removePropertyFromWishlist(String wishlistId, String propertyId) =>
      apiService.deleteApi(
        ApiUrl.wishlistProperties
            .replaceAll('{wishlistId}', wishlistId)
            .replaceAll('{propertyId}', propertyId),
        const {},
        WishlistModel.fromResponseJson,
      );

  Future<Either<AppException, BaseResponseModel<FavoriteModel>>> addFavorite(
    String id,
  ) => apiService.postApi<FavoriteModel>(
    ApiUrl.favorite.replaceAll('{propertyId}', id),
    const {},
    FavoriteModel.fromJson,
  );

  Future<Either<AppException, BaseResponseModel<FavoriteModel>>> removeFavorite(
    String id,
  ) => apiService.deleteApi<FavoriteModel>(
    ApiUrl.favorite.replaceAll('{propertyId}', id),
    const {},
    FavoriteModel.fromJson,
  );

  Future<Either<AppException, BaseResponseModel<dynamic>>> markRecentlyViewed(
    String id,
  ) => apiService.postApi<dynamic>(
    ApiUrl.recentlyViewedProperty.replaceAll('{id}', id),
    const {},
    (_) => null,
  );

  static List<WishlistModel> _wishlistList(dynamic value) => value is List
      ? value
            .whereType<Map>()
            .map(
              (item) => WishlistModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList()
      : const [];
}
