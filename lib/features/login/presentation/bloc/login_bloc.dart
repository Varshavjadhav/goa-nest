import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginIdentifierChanged>((event, emit) {
      emit(
        state.copyWith(
          identifier: event.identifier,
          identifierError: null,
          status: LoginStatus.initial,
        ),
      );
    });
    on<LoginPasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          password: event.password,
          passwordError: null,
          status: LoginStatus.initial,
        ),
      );
    });
    on<LoginPasswordVisibilityToggled>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });
    on<LoginRememberMeToggled>((event, emit) {
      emit(state.copyWith(rememberMe: !state.rememberMe));
    });
    on<LoginSubmitted>((event, emit) {
      final identifierError = _validateIdentifier(state.identifier);
      final passwordError = _validatePassword(state.password);

      if (identifierError != null || passwordError != null) {
        emit(
          state.copyWith(
            identifierError: identifierError,
            passwordError: passwordError,
            status: LoginStatus.failure,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: LoginStatus.submitting,
          message: null,
          identifierError: null,
          passwordError: null,
        ),
      );

      emit(
        state.copyWith(
          status: LoginStatus.success,
          message: 'Login successful',
        ),
      );
    });
  }

  String? _validateIdentifier(String identifier) {
    if (identifier.trim().isEmpty) {
      return 'Please enter your mobile number';
    }
    final digitsOnly = identifier.trim().replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 10) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter your password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
