import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/get_home.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeUseCase getHome;

  HomeBloc(this.getHome) : super(HomeInitial()) {
    on<LoadHome>((event, emit) async {
      emit(HomeLoading());
      final result = await getHome();
      result.fold(
        (error) => emit(HomeError(error.message)),
        (home) => emit(HomeLoaded(home)),
      );
    });
  }
}
