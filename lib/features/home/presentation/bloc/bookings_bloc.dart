import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/booking_model.dart';
import '../../domain/usecase/booking_usecases.dart';
import 'bookings_event.dart';
import 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final GetBookingsUseCase getBookings;
  final CancelBookingUseCase cancelBooking;

  BookingsBloc(this.getBookings, this.cancelBooking)
    : super(BookingsInitial()) {
    on<LoadBookings>((event, emit) async {
      emit(BookingsLoading());
      final result = await getBookings(status: event.status);
      result.fold(
        (error) => emit(BookingsError(error.message)),
        (collection) => emit(BookingsLoaded(collection)),
      );
    });
    on<CancelBooking>((event, emit) async {
      final current = state is BookingsLoaded
          ? (state as BookingsLoaded).collection
          : state is BookingsUpdating
          ? (state as BookingsUpdating).collection
          : const BookingCollection();
      emit(BookingsUpdating(current));
      final result = await cancelBooking(event.bookingId, event.reason);
      result.fold(
        (error) => emit(BookingsError(error.message, previous: current)),
        (_) => add(LoadBookings()),
      );
    });
  }
}
