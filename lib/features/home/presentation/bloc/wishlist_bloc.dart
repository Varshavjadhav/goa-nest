import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/home_repository.dart';
import '../../domain/usecase/get_wishlists.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlistsUseCase getWishlists;
  final HomeRepository repository;

  WishlistBloc(this.getWishlists, this.repository) : super(WishlistInitial()) {
    on<LoadWishlists>((event, emit) async {
      emit(WishlistLoading());
      final result = await getWishlists();
      result.fold(
        (error) => emit(WishlistError(error.message)),
        (wishlists) => emit(WishlistLoaded(wishlists)),
      );
    });
    on<ToggleFavorite>((event, emit) async {
      final result = event.isLiked
          ? await repository.removeFavorite(event.propertyId)
          : await repository.addFavorite(event.propertyId);
      result.fold(
        (error) => emit(WishlistError(error.message)),
        (_) => emit(FavoriteUpdated(event.propertyId, !event.isLiked)),
      );
    });
  }
}
