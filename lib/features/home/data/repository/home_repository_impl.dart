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
import '../model/booking_model.dart';
import '../model/review_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<AppException, ExploreModel>> getExplore({String tab = 'all'}) =>
      remoteDataSource.getExplore(tab: tab).mapEntity((data) => data);

  @override
  Future<Either<AppException, ProfileModel>> getProfile() =>
      remoteDataSource.getProfile().mapEntity((data) => data);

  @override
  Future<Either<AppException, ProfileModel>> updateProfile(
    ProfileUpdateRequest request,
  ) async {
    final result = await remoteDataSource.updateProfile(request);
    return result.fold(Left.new, (response) {
      final profile = response.data;
      if (profile == null) return Left(UnknownError());
      return Right(profile.copyWith(message: response.message));
    });
  }

  @override
  Future<Either<AppException, PropertyDetailModel>> getProperty(
    String id, {String? checkIn, String? checkOut}
  ) => remoteDataSource.getProperty(id, checkIn: checkIn, checkOut: checkOut)
      .mapEntity((data) => data);

  @override
  Future<Either<AppException, AvailabilityResult>> checkAvailability(
    AvailabilityRequest request,
  ) async {
    final result = await remoteDataSource.checkAvailability(request);
    return result.fold(Left.new, (response) {
      final availability = response.data;
      if (availability == null) return Left(UnknownError());
      return Right(availability.copyWith(message: response.message));
    });
  }

  @override
  Future<Either<AppException, BookingCollection>> getBookings({
    String? status,
    int page = 1,
    int limit = 20,
  }) => remoteDataSource
      .getBookings(status: status, page: page, limit: limit)
      .mapEntity((data) => data);

  @override
  Future<Either<AppException, BookingModel>> getBooking(String bookingId) =>
      remoteDataSource.getBooking(bookingId).mapEntity((data) => data);

  @override
  Future<Either<AppException, BookingModel>> createBooking(
    CreateBookingRequest request,
  ) => remoteDataSource.createBooking(request).mapEntity((data) => data);

  @override
  Future<Either<AppException, BookingModel>> cancelBooking(
    String bookingId,
    String reason,
  ) => remoteDataSource
      .cancelBooking(bookingId, reason)
      .mapEntity((data) => data);

  @override
  Future<Either<AppException, ReviewModel>> createReview(
    String propertyId,
    String bookingId,
    int rating,
    String comment,
  ) async {
    final result = await remoteDataSource.createReview(
      propertyId,
      bookingId,
      rating,
      comment,
    );
    return result.fold(Left.new, (response) {
      final review = response.data;
      if (review == null) return Left(UnknownError());
      return Right(review.copyWith(message: response.message));
    });
  }

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
  Future<Either<AppException, WishlistModel>> createWishlist(String name) async {
    final result = await remoteDataSource.createWishlist(name);
    return result.fold(Left.new, (response) {
      final wishlist = response.data;
      if (wishlist == null) return Left(UnknownError());
      return Right(wishlist.copyWith(message: response.message));
    });
  }

  @override
  Future<Either<AppException, WishlistModel>> addPropertyToWishlist(
    String wishlistId,
    String propertyId,
  ) async {
    final result = await remoteDataSource.addPropertyToWishlist(
      wishlistId,
      propertyId,
    );
    return result.fold(Left.new, (response) {
      final wishlist = response.data;
      if (wishlist == null) return Left(UnknownError());
      return Right(wishlist.copyWith(message: response.message));
    });
  }

  @override
  Future<Either<AppException, WishlistModel>> removePropertyFromWishlist(
    String wishlistId,
    String propertyId,
  ) async {
    final result = await remoteDataSource.removePropertyFromWishlist(
      wishlistId,
      propertyId,
    );
    return result.fold(Left.new, (response) {
      final wishlist = response.data;
      if (wishlist == null) return Left(UnknownError());
      return Right(wishlist.copyWith(message: response.message));
    });
  }

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
