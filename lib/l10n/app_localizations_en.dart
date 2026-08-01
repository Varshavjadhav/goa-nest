// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'GoaNest';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageMarathi => 'Marathi';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noInternet => 'No Internet';

  @override
  String get requestTimedOut => 'Request Timed Out';

  @override
  String get sessionExpired => 'Session Expired';

  @override
  String get accessDenied => 'Access Denied';

  @override
  String get unauthorized => 'Unauthorized';

  @override
  String get notFoundError => 'Not Found Error';

  @override
  String get serverError => 'Server Error';

  @override
  String get badRequestError => 'Bad Request Error';

  @override
  String get serviceUnavailableError => 'Service Unavailable Error';

  @override
  String get methodNotAllowedError => 'Method Not Allowed Error';

  @override
  String get tooManyRequestsError => 'Too Many Requests Error';

  @override
  String get badGatewayError => 'Bad Gateway Error';

  @override
  String get httpVersionNotSupportedError => 'HTTP Version Not Supported Error';

  @override
  String get unknownError => 'Unknown Error';
}
