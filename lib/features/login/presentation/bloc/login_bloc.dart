import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goanest/features/login/domain/usecase/get_login.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GetLoginUseCase login;

  LoginBloc(this.login) : super(const LoginState()) {
    on<LoginIdentifierChanged>((event, emit) {
      emit(
        state.copyWith(
          identifier: event.identifier,
          status: LoginStatus.initial,
          clearIdentifierError: true,
          clearMessage: true,
        ),
      );
    });
    on<LoginPasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          password: event.password,
          status: LoginStatus.initial,
          clearPasswordError: true,
          clearMessage: true,
        ),
      );
    });
    on<LoginPasswordVisibilityToggled>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });
    on<LoginRememberMeToggled>((event, emit) {
      emit(state.copyWith(rememberMe: !state.rememberMe));
    });
    on<LoginSubmitted>(_submit);
  }

  Future<void> _submit(LoginSubmitted event, Emitter<LoginState> emit) async {
    final identifierError = _validateIdentifier(state.identifier);
    final passwordError = _validatePassword(state.password);

    if (identifierError != null || passwordError != null) {
      emit(
        state.copyWith(
          identifierError: identifierError,
          passwordError: passwordError,
          status: LoginStatus.failure,
          clearMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: LoginStatus.submitting,
        message: null,
        clearIdentifierError: true,
        clearPasswordError: true,
        clearMessage: true,
      ),
    );

    final result = await login(
      email: state.identifier.trim(),
      password: state.password,
    );

    result.fold(
      (error) => emit(
        state.copyWith(status: LoginStatus.failure, message: error.message),
      ),
      (response) => emit(
        state.copyWith(
          status: LoginStatus.success,
          message: response.message.isEmpty
              ? 'Login successful'
              : response.message,
        ),
      ),
    );
  }

  String? _validateIdentifier(String identifier) {
    if (identifier.trim().isEmpty) {
      return 'Please enter your email address';
    }
    final email = identifier.trim();
    if (email.length > 254 ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }
}
