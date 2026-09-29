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
        (wishlist) => emit(
          WishlistLoaded(
            [..._currentWishlists, wishlist],
            message: wishlist.message,
          ),
        ),
      );
    });
    on<AddPropertyToWishlist>((event, emit) async {
      final result = await addProperty(event.wishlistId, event.propertyId);
      result.fold(
        (error) => emit(WishlistActionError(error.message, _currentWishlists)),
        (wishlist) => emit(
          WishlistLoaded(
            _replaceWishlist(wishlist),
            message: wishlist.message,
          ),
        ),
      );
    });
    on<RemovePropertyFromWishlist>((event, emit) async {
      final result = await removeProperty(event.wishlistId, event.propertyId);
      result.fold(
        (error) => emit(WishlistActionError(error.message, _currentWishlists)),
        (wishlist) => emit(
          WishlistLoaded(
            _replaceWishlist(wishlist),
            message: wishlist.message,
          ),
        ),
      );
    });
    on<ToggleFavorite>((event, emit) async {
      final wishlists = _currentWishlists;
      WishlistModel? containingWishlist;
      for (final wishlist in wishlists) {
        if (wishlist.properties.any(
          (item) => item.property?.id == event.propertyId,
        )) {
          containingWishlist = wishlist;
          break;
        }
      }

      if (event.isLiked && containingWishlist != null) {
        final wishlistResult = await removeProperty(
          containingWishlist.id,
          event.propertyId,
        );
        wishlistResult.fold(
          (error) => emit(
            FavoriteError(
              event.propertyId,
              event.isLiked,
              error.message,
              _currentWishlists,
            ),
          ),
          (wishlist) => emit(
            FavoriteUpdated(
              event.propertyId,
              !event.isLiked,
              _replaceWishlist(wishlist),
              message: wishlist.message,
            ),
          ),
        );
        return;
      }

      if (!event.isLiked && wishlists.isNotEmpty) {
        final wishlist = wishlists.first;
        final result = await addProperty(wishlist.id, event.propertyId);
        result.fold(
          (error) => emit(
            FavoriteError(
              event.propertyId,
              event.isLiked,
              error.message,
              wishlists,
            ),
          ),
          (updatedWishlist) => emit(
            FavoriteUpdated(
              event.propertyId,
              true,
              _replaceWishlist(updatedWishlist),
              message: updatedWishlist.message,
            ),
          ),
        );
        return;
      }

      if (!event.isLiked) {
        final createdResult = await createWishlist('Saved stays');
        final createdWishlist = createdResult.fold(
          (error) {
            emit(
              FavoriteError(
                event.propertyId,
                event.isLiked,
                error.message,
                wishlists,
              ),
            );
            return null;
          },
          (wishlist) => wishlist,
        );
        if (createdWishlist == null) return;

        final addResult = await addProperty(
          createdWishlist.id,
          event.propertyId,
        );
        addResult.fold(
          (error) => emit(
            FavoriteError(
              event.propertyId,
              event.isLiked,
              error.message,
              [...wishlists, createdWishlist],
            ),
          ),
          (updatedWishlist) => emit(
            FavoriteUpdated(
              event.propertyId,
              true,
              [updatedWishlist],
              message: updatedWishlist.message,
            ),
          ),
        );
        return;
      }

      final result = event.isLiked
          ? await repository.removeFavorite(event.propertyId)
          : await repository.addFavorite(event.propertyId);
      result.fold(
        (error) => emit(
          FavoriteError(
            event.propertyId,
            event.isLiked,
            error.message,
            _currentWishlists,
          ),
        ),
        (favorite) => emit(
          FavoriteUpdated(
            event.propertyId,
            favorite.isLiked,
            _currentWishlists,
          ),
        ),
      );
    });
  }

  List<WishlistModel> get _currentWishlists => state is WishlistLoaded
      ? (state as WishlistLoaded).wishlists
      : state is WishlistActionError
      ? (state as WishlistActionError).wishlists
      : state is FavoriteUpdated
      ? (state as FavoriteUpdated).wishlists
      : state is FavoriteError
      ? (state as FavoriteError).wishlists
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
