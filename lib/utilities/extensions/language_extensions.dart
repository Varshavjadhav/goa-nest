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
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
