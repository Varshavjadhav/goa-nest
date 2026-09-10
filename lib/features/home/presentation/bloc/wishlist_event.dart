abstract class WishlistEvent {}

class LoadWishlists extends WishlistEvent {}

class ToggleFavorite extends WishlistEvent {
  final String propertyId;
  final bool isLiked;
  ToggleFavorite(this.propertyId, {required this.isLiked});
}
