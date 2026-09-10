import '../../data/model/explore_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final ExploreModel home;
  HomeLoaded(this.home);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
