enum LoginStatus { initial, submitting, success, failure }

class LoginState {
  final LoginStatus status;
  final String? message;
  final String identifier;
  final String password;
  final bool obscurePassword;
  final bool rememberMe;
  final String? identifierError;
  final String? passwordError;

  const LoginState({
    this.status = LoginStatus.initial,
    this.message,
    this.identifier = '',
    this.password = '',
    this.obscurePassword = true,
    this.rememberMe = true,
    this.identifierError,
    this.passwordError,
  });

  bool get isSubmitting => status == LoginStatus.submitting;

  LoginState copyWith({
    LoginStatus? status,
    String? message,
    String? identifier,
    String? password,
    bool? obscurePassword,
    bool? rememberMe,
    String? identifierError,
    String? passwordError,
  }) {
    return LoginState(
      status: status ?? this.status,
      message: message ?? this.message,
      identifier: identifier ?? this.identifier,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      identifierError: identifierError ?? this.identifierError,
      passwordError: passwordError ?? this.passwordError,
    );
  }
}
