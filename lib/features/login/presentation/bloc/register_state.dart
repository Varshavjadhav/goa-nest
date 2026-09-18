enum RegisterStatus { initial, submitting, success, failure }

class RegisterState {
  final RegisterStatus status;
  final String name;
  final String email;
  final String phone;
  final String password;
  final bool obscurePassword;
  final String? nameError;
  final String? emailError;
  final String? phoneError;
  final String? passwordError;
  final String? message;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.obscurePassword = true,
    this.nameError,
    this.emailError,
    this.phoneError,
    this.passwordError,
    this.message,
  });
  bool get isSubmitting => status == RegisterStatus.submitting;

  RegisterState copyWith({
    RegisterStatus? status,
    String? name,
    String? email,
    String? phone,
    String? password,
    bool? obscurePassword,
    String? nameError,
    String? emailError,
    String? phoneError,
    String? passwordError,
    String? message,
    bool clearErrors = false,
  }) => RegisterState(
    status: status ?? this.status,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    password: password ?? this.password,
    obscurePassword: obscurePassword ?? this.obscurePassword,
    nameError: clearErrors ? null : nameError ?? nameError,
    emailError: clearErrors ? null : emailError ?? emailError,
    phoneError: clearErrors ? null : phoneError ?? phoneError,
    passwordError: clearErrors ? null : passwordError ?? passwordError,
    message: message ?? this.message,
  );
}
