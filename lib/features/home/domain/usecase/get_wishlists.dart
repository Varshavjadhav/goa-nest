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
