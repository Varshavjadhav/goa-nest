import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/get_recently_viewed.dart';
import 'recently_viewed_event.dart';
import 'recently_viewed_state.dart';

class RecentlyViewedBloc
    extends Bloc<RecentlyViewedEvent, RecentlyViewedState> {
  final GetRecentlyViewedUseCase getRecentlyViewed;

  RecentlyViewedBloc(this.getRecentlyViewed) : super(RecentlyViewedInitial()) {
    on<LoadRecentlyViewed>((event, emit) async {
      emit(RecentlyViewedLoading());
      final result = await getRecentlyViewed(
        page: event.page,
        limit: event.limit,
      );
      result.fold(
        (error) => emit(RecentlyViewedError(error.message)),
        (data) => emit(RecentlyViewedLoaded(data)),
      );
    });
  }
}
