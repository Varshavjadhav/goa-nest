import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/view/app.dart';
import 'core/di/injector.dart';
import 'core/observer/app_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppObserver();
  setupServiceLocator();

  runApp(const App());
}
