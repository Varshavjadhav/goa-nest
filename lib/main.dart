import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/bloc/language/language_bloc.dart';
import 'app/bloc/theme/theme_bloc.dart';
import 'app/view/app.dart';
import 'core/di/injector.dart';
import 'core/observer/app_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppObserver();
  setupServiceLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => LanguageBloc()),
      ],
      child: const App(),
    ),
  );
}
