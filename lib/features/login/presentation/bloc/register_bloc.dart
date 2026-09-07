import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goanest/features/login/domain/usecase/register_user.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUseCase registerUser;
  RegisterBloc(this.registerUser) : super(const RegisterState()) {
    on<RegisterNameChanged>(
      (e, emit) => emit(
        state.copyWith(
          name: e.value,
          status: RegisterStatus.initial,
          clearErrors: true,
        ),
      ),
    );
    on<RegisterEmailChanged>(
      (e, emit) => emit(
        state.copyWith(
          email: e.value,
          status: RegisterStatus.initial,
          clearErrors: true,
        ),
      ),
    );
    on<RegisterPasswordChanged>(
      (e, emit) => emit(
        state.copyWith(
          password: e.value,
          status: RegisterStatus.initial,
          clearErrors: true,
        ),
      ),
    );
    on<RegisterPasswordVisibilityToggled>(
      (e, emit) =>
          emit(state.copyWith(obscurePassword: !state.obscurePassword)),
    );
    on<RegisterSubmitted>(_submit);
  }

  Future<void> _submit(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final nameError = state.name.trim().isEmpty
        ? 'Please enter your name'
        : null;
    final emailError = state.email.trim().isEmpty
        ? 'Please enter your email address'
        : (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(state.email.trim())
              ? 'Enter a valid email address'
              : null);
    final passwordError = state.password.length < 6
        ? 'Password must be at least 6 characters'
        : null;
    if (nameError != null || emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          nameError: nameError,
          emailError: emailError,
          passwordError: passwordError,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: RegisterStatus.submitting,
        message: null,
        clearErrors: true,
      ),
    );
    final result = await registerUser(
      name: state.name.trim(),
      email: state.email.trim(),
      password: state.password,
    );
    result.fold(
      (error) => emit(
        state.copyWith(status: RegisterStatus.failure, message: error.message),
      ),
      (_) => emit(
        state.copyWith(
          status: RegisterStatus.success,
          message: 'Registration successful',
        ),
      ),
    );
  }
}
