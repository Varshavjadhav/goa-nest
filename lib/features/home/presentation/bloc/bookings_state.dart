import '../../data/model/booking_model.dart';

abstract class BookingsState {}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final BookingCollection collection;
  BookingsLoaded(this.collection);
}

class BookingsError extends BookingsState {
  final String message;
  final BookingCollection? previous;
  BookingsError(this.message, {this.previous});
}

class BookingsUpdating extends BookingsState {
  final BookingCollection collection;
  BookingsUpdating(this.collection);
}
