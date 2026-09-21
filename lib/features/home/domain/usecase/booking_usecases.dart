import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import '../../data/model/booking_model.dart';
import '../repository/home_repository.dart';

class GetBookingsUseCase {
  final HomeRepository repository;
  const GetBookingsUseCase(this.repository);

  Future<Either<AppException, BookingCollection>> call({String? status}) =>
      repository.getBookings(status: status);
}

class CreateBookingUseCase {
  final HomeRepository repository;
  const CreateBookingUseCase(this.repository);

  Future<Either<AppException, BookingModel>> call(
    CreateBookingRequest request,
  ) => repository.createBooking(request);
}

class CancelBookingUseCase {
  final HomeRepository repository;
  const CancelBookingUseCase(this.repository);

  Future<Either<AppException, BookingModel>> call(
    String bookingId,
    String reason,
  ) => repository.cancelBooking(bookingId, reason);
}
