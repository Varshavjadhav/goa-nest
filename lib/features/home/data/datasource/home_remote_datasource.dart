import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/data/network/response/base_response_model.dart';
import 'package:goanest/core/data/network/service/base_api_service.dart';
import 'package:goanest/resources/constants/url_end_points.dart';

import '../model/home_model.dart';
import '../model/property_detail_model.dart';
import '../model/wishlist_model.dart';

class HomeRemoteDataSource {
  final BaseApiServices apiService;

  const HomeRemoteDataSource(this.apiService);

  Future<Either<AppException, BaseResponseModel<HomeModel>>> getHome() =>
      apiService.getApi(ApiUrl.home, const {}, HomeModel.fromJson);

  Future<Either<AppException, BaseResponseModel<PropertyDetailModel>>>
  getProperty(String propertyId) => apiService.getApi(
    ApiUrl.propertyDetails.replaceAll('{id}', propertyId),
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

  Future<Either<AppException, BaseResponseModel<List<WishlistModel>>>>
  getWishlists() => apiService.getApi(
    ApiUrl.wishlists,
    const {},
    (json) => _wishlistList(json['wishlists']),
  );

  Future<Either<AppException, BaseResponseModel<dynamic>>> addFavorite(
    String id,
  ) => apiService.postApi<dynamic>(
    ApiUrl.favorites.replaceAll('{id}', id),
    const {},
    (_) => null,
  );

  Future<Either<AppException, BaseResponseModel<dynamic>>> removeFavorite(
    String id,
  ) => apiService.deleteApi<dynamic>(
    ApiUrl.favorites.replaceAll('{id}', id),
    const {},
    (_) => null,
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
