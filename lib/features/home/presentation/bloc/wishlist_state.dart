import '../../data/model/wishlist_model.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistModel> wishlists;
  WishlistLoaded(this.wishlists);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}

class WishlistActionError extends WishlistState {
  final String message;
  final List<WishlistModel> wishlists;
  WishlistActionError(this.message, this.wishlists);
}

class FavoriteUpdated extends WishlistState {
  final String propertyId;
  final bool isLiked;
  FavoriteUpdated(this.propertyId, this.isLiked);
}

class FavoriteError extends WishlistState {
  final String propertyId;
  final bool previousIsLiked;
  final String message;

  FavoriteError(this.propertyId, this.previousIsLiked, this.message);
}
