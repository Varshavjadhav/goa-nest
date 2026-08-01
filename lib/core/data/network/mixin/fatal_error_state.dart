import '../../error/app_exception.dart';

abstract class FatalErrorState {
  AppException? get fatalError;
}
