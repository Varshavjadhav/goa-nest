import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import '../../data/model/wishlist_model.dart';
import '../repository/home_repository.dart';

class GetWishlistsUseCase {
  final HomeRepository repository;
  const GetWishlistsUseCase(this.repository);

  Future<Either<AppException, List<WishlistModel>>> call() =>
      repository.getWishlists();
}

class CreateWishlistUseCase {
  final HomeRepository repository;
  const CreateWishlistUseCase(this.repository);

  Future<Either<AppException, WishlistModel>> call(String name) =>
      repository.createWishlist(name);
}

class AddPropertyToWishlistUseCase {
  final HomeRepository repository;
  const AddPropertyToWishlistUseCase(this.repository);

  Future<Either<AppException, WishlistModel>> call(
    String wishlistId,
    String propertyId,
  ) => repository.addPropertyToWishlist(wishlistId, propertyId);
}

class RemovePropertyFromWishlistUseCase {
  final HomeRepository repository;
  const RemovePropertyFromWishlistUseCase(this.repository);

  Future<Either<AppException, WishlistModel>> call(
    String wishlistId,
    String propertyId,
  ) => repository.removePropertyFromWishlist(wishlistId, propertyId);
}
