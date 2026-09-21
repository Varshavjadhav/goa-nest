abstract class HomeEvent {}

class LoadHome extends HomeEvent {
  final String tab;

  LoadHome({this.tab = 'all'});
}
