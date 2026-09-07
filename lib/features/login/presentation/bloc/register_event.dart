abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterNameChanged extends RegisterEvent {
  final String value;
  const RegisterNameChanged(this.value);
}

class RegisterEmailChanged extends RegisterEvent {
  final String value;
  const RegisterEmailChanged(this.value);
}

class RegisterPasswordChanged extends RegisterEvent {
  final String value;
  const RegisterPasswordChanged(this.value);
}

class RegisterPasswordVisibilityToggled extends RegisterEvent {
  const RegisterPasswordVisibilityToggled();
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
