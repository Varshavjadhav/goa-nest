import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../core.dart';
import '../../resources/constants/constants.dart';
import '../../resources/theme/theme.dart';
import '../../utilities/global.dart';
import '../../utilities/ui_config/app_size_config.dart';
import '../bloc/language/language_bloc.dart';
import '../bloc/language/language_state.dart';
// Import your blocs
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_state.dart';
import '../router/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig.init(constraints, orientation);

            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, languageState) {
                    return MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      title: Constants.appName,

                      themeMode: themeState.themeMode,
                      theme: AppTheme.light,
                      darkTheme: AppTheme.dark,

                      locale: languageState.locale,

                      supportedLocales: AppLocalizations.supportedLocales,
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                      ],

                      routerConfig: AppRouter.router,
                      scaffoldMessengerKey: Global.scaffoldMessengerKey,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
