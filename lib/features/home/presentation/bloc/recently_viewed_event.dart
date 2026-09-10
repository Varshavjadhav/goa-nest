abstract class RecentlyViewedEvent {}

class LoadRecentlyViewed extends RecentlyViewedEvent {
  final int page;
  final int limit;
  LoadRecentlyViewed({this.page = 1, this.limit = 20});
}
