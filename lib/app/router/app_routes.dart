import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/features/home/presentation/view/filter_screen.dart';
import 'package:goanest/features/home/presentation/view/home_screen.dart';
import 'package:goanest/features/login/presentation/view/login_screen.dart';
import 'package:goanest/features/login/presentation/view/registration_screen.dart';
import 'package:goanest/features/splash/presentaion/screens/splash_screen.dart';

import '../../core.dart';
import '../../utilities/extensions/extensions.dart';
import '../../utilities/global.dart';
import '../../widgets/app_page_not_found.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteName.splashView,
    navigatorKey: Global.navigatorKey,
    debugLogDiagnostics: true,
    // restorationScopeId: Constants.appName,
    // observers: [FirebaseAnalyticsObserver(analytics: AnalyticsService.instance)],
    requestFocus: false,
    routes: [
      // GoRoute(
      //   name: RouteName.forceUpdateView.removeFirstChar(),
      //   path: RouteName.forceUpdateView,
      //   pageBuilder: (context, state) => appCustomTransitionPage(state: state, child: const ForceUpdateView()),
      // ),
      GoRoute(
        name: RouteName.splashView.removeFirstChar(),
        path: RouteName.splashView,
        pageBuilder: (context, state) =>
            appCustomTransitionPage(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        name: RouteName.loginView.removeFirstChar(),
        path: RouteName.loginView,
        pageBuilder: (context, state) =>
            appCustomTransitionPage(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        name: RouteName.registerView.removeFirstChar(),
        path: RouteName.registerView,
        pageBuilder: (context, state) => appCustomTransitionPage(
          state: state,
          child: const RegistrationScreen(),
        ),
      ),
      GoRoute(
        name: RouteName.homeView.removeFirstChar(),
        path: RouteName.homeView,
        pageBuilder: (context, state) =>
            appCustomTransitionPage(state: state, child: const HomeScreen()),
      ),
      GoRoute(
        name: RouteName.filterView.removeFirstChar(),
        path: RouteName.filterView,
        pageBuilder: (context, state) => appCustomTransitionPage(
          state: state,
          transitionBuilder: slideInOutTransition,
          child: const FilterScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => const AppPageNotFound(),
  );

  static CustomTransitionPage<dynamic> appCustomTransitionPage({
    required GoRouterState state,
    required Widget child,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
        transitionBuilder =
        transition,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: transitionBuilder,
      transitionDuration: const Duration(milliseconds: 0),
      reverseTransitionDuration: const Duration(milliseconds: 0),
    );
  }

  static Widget transition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget slideInOutTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    final inAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(animation);

    final outAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0.0),
    ).animate(secondaryAnimation);

    return SlideTransition(
      position: inAnimation,
      child: SlideTransition(position: outAnimation, child: child),
    );
  }
}
