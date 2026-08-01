import 'package:flutter/services.dart';

class AppInputFormatters {
  AppInputFormatters._();

  static final nameFormatter = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));

  static final emailFormatter = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._%+-]'));

  static final ageFormatter = [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)];

  static final phoneFormatter = [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)];
}
