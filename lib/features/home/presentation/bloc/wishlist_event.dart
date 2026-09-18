abstract class WishlistEvent {}

class LoadWishlists extends WishlistEvent {}

class CreateWishlist extends WishlistEvent {
  final String name;
  CreateWishlist(this.name);
}

class AddPropertyToWishlist extends WishlistEvent {
  final String wishlistId;
  final String propertyId;
  AddPropertyToWishlist(this.wishlistId, this.propertyId);
}

class RemovePropertyFromWishlist extends WishlistEvent {
  final String wishlistId;
  final String propertyId;
  RemovePropertyFromWishlist(this.wishlistId, this.propertyId);
}

class ToggleFavorite extends WishlistEvent {
  final String propertyId;
  final bool isLiked;
  ToggleFavorite(this.propertyId, {required this.isLiked});
}
