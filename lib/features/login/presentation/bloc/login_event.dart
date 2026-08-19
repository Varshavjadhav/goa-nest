abstract class LoginEvent {
  const LoginEvent();
}

class LoginIdentifierChanged extends LoginEvent {
  final String identifier;
  const LoginIdentifierChanged(this.identifier);
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged(this.password);
}

class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

class LoginRememberMeToggled extends LoginEvent {
  const LoginRememberMeToggled();
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
