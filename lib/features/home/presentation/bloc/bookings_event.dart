abstract class BookingsEvent {}

class LoadBookings extends BookingsEvent {
  final String? status;
  LoadBookings({this.status});
}

class CancelBooking extends BookingsEvent {
  final String bookingId;
  final String reason;
  CancelBooking(this.bookingId, {this.reason = 'Cancelled by guest'});
}
