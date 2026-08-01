// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'GoaNest';

  @override
  String get languageEnglish => 'इंग्रजी';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get tryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get noInternet => 'इंटरनेट उपलब्ध नाही';

  @override
  String get requestTimedOut => 'विनंतीची वेळ संपली';

  @override
  String get sessionExpired => 'सत्र संपले';

  @override
  String get accessDenied => 'प्रवेश नाकारला';

  @override
  String get unauthorized => 'अनधिकृत';

  @override
  String get notFoundError => 'सापडले नाही';

  @override
  String get serverError => 'सर्व्हर त्रुटी';

  @override
  String get badRequestError => 'चुकीची विनंती';

  @override
  String get serviceUnavailableError => 'सेवा उपलब्ध नाही';

  @override
  String get methodNotAllowedError => 'ही पद्धत अनुमत नाही';

  @override
  String get tooManyRequestsError => 'खूप जास्त विनंत्या';

  @override
  String get badGatewayError => 'खराब गेटवे';

  @override
  String get httpVersionNotSupportedError => 'HTTP आवृत्ती समर्थित नाही';

  @override
  String get unknownError => 'अज्ञात त्रुटी';
}
