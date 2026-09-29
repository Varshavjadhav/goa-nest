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
          clearMessage: true,
        ),
      ),
    );
    on<RegisterEmailChanged>(
      (e, emit) => emit(
        state.copyWith(
          email: e.value,
          status: RegisterStatus.initial,
          clearErrors: true,
          clearMessage: true,
        ),
      ),
    );
    on<RegisterPhoneChanged>(
      (e, emit) => emit(
        state.copyWith(
          phone: e.value,
          status: RegisterStatus.initial,
          clearErrors: true,
          clearMessage: true,
        ),
      ),
    );
    on<RegisterPasswordChanged>(
      (e, emit) => emit(
        state.copyWith(
          password: e.value,
          status: RegisterStatus.initial,
          clearErrors: true,
          clearMessage: true,
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
    final name = state.name.trim();
    final email = state.email.trim();
    final phone = state.phone.trim();
    final nameError = name.isEmpty
        ? 'Please enter your name'
        : name.length < 2
        ? 'Name must be at least 2 characters'
        : name.length > 50
        ? 'Name cannot exceed 50 characters'
        : null;
    final emailError = email.isEmpty
        ? 'Please enter your email address'
        : (email.length > 254 ||
                !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
              ? 'Enter a valid email address'
              : null);
    final phoneError = phone.isEmpty
        ? 'Please enter your phone number'
        : (!RegExp(r'^\+?[0-9\s().-]{7,20}$').hasMatch(phone)
              ? 'Enter a valid phone number'
              : null);
    final passwordError = state.password.length < 6
        ? 'Password must be at least 6 characters'
        : null;
    if (nameError != null ||
        emailError != null ||
        phoneError != null ||
        passwordError != null) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          nameError: nameError,
          emailError: emailError,
          phoneError: phoneError,
          passwordError: passwordError,
          clearMessage: true,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: RegisterStatus.submitting,
        message: null,
        clearErrors: true,
        clearMessage: true,
      ),
    );
    final result = await registerUser(
      name: state.name.trim(),
      email: state.email.trim(),
      phone: state.phone.trim(),
      password: state.password,
    );
    result.fold(
      (error) => emit(
        state.copyWith(status: RegisterStatus.failure, message: error.message),
      ),
      (response) => emit(
        state.copyWith(
          status: RegisterStatus.success,
          message: response.message.isEmpty
              ? 'Registration successful'
              : response.message,
        ),
      ),
    );
  }
}
