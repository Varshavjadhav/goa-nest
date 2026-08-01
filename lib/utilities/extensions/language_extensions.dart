import '../../core.dart';
import '../enums/enums_types.dart';
import '../global.dart';

extension LanguageExtension on Language {
  String displayName() {
    switch (this) {
      case Language.english:
        return Global.navigatorKey.currentContext!.loc.languageEnglish;
      case Language.marathi:
        return Global.navigatorKey.currentContext!.loc.languageMarathi;
      case Language.hindi:
        return Global.navigatorKey.currentContext!.loc.languageHindi;
    }
  }
}

Language resolveLanguageFromDevice() {
  return Language.english;
  /*final locale = WidgetsBinding.instance.platformDispatcher.locale;
  final languageCode = locale.languageCode;

  switch (languageCode) {
    case 'mr':
      return Language.marathi;
    case 'hi':
      return Language.hindi;
    case 'en':
    default:
      return Language.english;
  }*/
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
