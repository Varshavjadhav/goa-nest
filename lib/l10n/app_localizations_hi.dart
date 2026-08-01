// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'GoaNest';

  @override
  String get languageEnglish => 'अंग्रेजी';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get noInternet => 'इंटरनेट उपलब्ध नहीं है';

  @override
  String get requestTimedOut => 'अनुरोध का समय समाप्त हो गया';

  @override
  String get sessionExpired => 'सत्र समाप्त हो गया';

  @override
  String get accessDenied => 'पहुंच अस्वीकार की गई';

  @override
  String get unauthorized => 'अनधिकृत';

  @override
  String get notFoundError => 'नहीं मिला';

  @override
  String get serverError => 'सर्वर त्रुटि';

  @override
  String get badRequestError => 'गलत अनुरोध';

  @override
  String get serviceUnavailableError => 'सेवा उपलब्ध नहीं है';

  @override
  String get methodNotAllowedError => 'विधि की अनुमति नहीं है';

  @override
  String get tooManyRequestsError => 'बहुत अधिक अनुरोध';

  @override
  String get badGatewayError => 'खराब गेटवे';

  @override
  String get httpVersionNotSupportedError => 'HTTP संस्करण समर्थित नहीं है';

  @override
  String get unknownError => 'अज्ञात त्रुटि';
}
