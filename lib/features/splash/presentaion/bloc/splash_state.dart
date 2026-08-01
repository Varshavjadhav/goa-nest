import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitialState extends SplashState {
  const SplashInitialState();
}

class SplashLoadingState extends SplashState {
  const SplashLoadingState();
}

class SplashReadyState extends SplashState {
  final String nextRoute;

  const SplashReadyState({required this.nextRoute});

  @override
  List<Object?> get props => [nextRoute];
}

class SplashErrorState extends SplashState {
  final String message;

  const SplashErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
