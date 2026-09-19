import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import '../../data/model/booking_model.dart';
import '../repository/home_repository.dart';

class CheckAvailabilityUseCase {
  final HomeRepository repository;
  const CheckAvailabilityUseCase(this.repository);

  Future<Either<AppException, AvailabilityResult>> call(
    AvailabilityRequest request,
  ) => repository.checkAvailability(request);
}
