import '../../data/model/home_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeModel home;
  HomeLoaded(this.home);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
