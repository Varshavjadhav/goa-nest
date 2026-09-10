import '../../data/model/home_model.dart';

abstract class RecentlyViewedState {}

class RecentlyViewedInitial extends RecentlyViewedState {}

class RecentlyViewedLoading extends RecentlyViewedState {}

class RecentlyViewedLoaded extends RecentlyViewedState {
  final PropertyCollection result;
  RecentlyViewedLoaded(this.result);
}

class RecentlyViewedError extends RecentlyViewedState {
  final String message;
  RecentlyViewedError(this.message);
}
