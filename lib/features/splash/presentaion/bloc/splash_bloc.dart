import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goanest/app/router/route_name.dart';

import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  Timer? _navigationTimer;

  SplashBloc() : super(const SplashInitialState()) {
    on<SplashStarted>(_onSplashStarted);
    on<SplashFinished>(_onSplashFinished);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoadingState());
    _navigationTimer?.cancel();
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      if (!isClosed) {
        add(const SplashFinished());
      }
    });
  }

  void _onSplashFinished(SplashFinished event, Emitter<SplashState> emit) {
    emit(const SplashReadyState(nextRoute: RouteName.loginView));
  }

  @override
  Future<void> close() {
    _navigationTimer?.cancel();
    return super.close();
  }
}
