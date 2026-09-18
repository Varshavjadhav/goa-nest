import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/wishlist_model.dart';
import '../../domain/repository/home_repository.dart';
import '../../domain/usecase/get_wishlists.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlistsUseCase getWishlists;
  final CreateWishlistUseCase createWishlist;
  final AddPropertyToWishlistUseCase addProperty;
  final RemovePropertyFromWishlistUseCase removeProperty;
  final HomeRepository repository;

  WishlistBloc(
    this.getWishlists,
    this.createWishlist,
    this.addProperty,
    this.removeProperty,
    this.repository,
  ) : super(WishlistInitial()) {
    on<LoadWishlists>((event, emit) async {
      emit(WishlistLoading());
      final result = await getWishlists();
      result.fold(
        (error) => emit(WishlistError(error.message)),
        (wishlists) => emit(WishlistLoaded(wishlists)),
      );
    });
    on<CreateWishlist>((event, emit) async {
      final result = await createWishlist(event.name);
      result.fold(
        (error) => emit(WishlistActionError(error.message, _currentWishlists)),
        (wishlist) => emit(WishlistLoaded([..._currentWishlists, wishlist])),
      );
    });
    on<AddPropertyToWishlist>((event, emit) async {
      final result = await addProperty(event.wishlistId, event.propertyId);
      result.fold(
        (error) => emit(WishlistActionError(error.message, _currentWishlists)),
        (wishlist) => emit(WishlistLoaded(_replaceWishlist(wishlist))),
      );
    });
    on<RemovePropertyFromWishlist>((event, emit) async {
      final result = await removeProperty(event.wishlistId, event.propertyId);
      result.fold(
        (error) => emit(WishlistActionError(error.message, _currentWishlists)),
        (wishlist) => emit(WishlistLoaded(_replaceWishlist(wishlist))),
      );
    });
    on<ToggleFavorite>((event, emit) async {
      final result = event.isLiked
          ? await repository.removeFavorite(event.propertyId)
          : await repository.addFavorite(event.propertyId);
      result.fold(
        (error) =>
            emit(FavoriteError(event.propertyId, event.isLiked, error.message)),
        (favorite) => emit(FavoriteUpdated(event.propertyId, favorite.isLiked)),
      );
    });
  }

  List<WishlistModel> get _currentWishlists => state is WishlistLoaded
      ? (state as WishlistLoaded).wishlists
      : state is WishlistActionError
      ? (state as WishlistActionError).wishlists
      : const [];

  List<WishlistModel> _replaceWishlist(WishlistModel wishlist) {
    final items = [..._currentWishlists];
    final index = items.indexWhere((item) => item.id == wishlist.id);
    if (index == -1)
      items.add(wishlist);
    else
      items[index] = wishlist;
    return items;
  }
}
