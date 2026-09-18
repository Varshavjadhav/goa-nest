import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/features/home/presentation/view/filter_screen.dart';
import 'package:goanest/features/home/presentation/widget/search_widget.dart';
import 'package:goanest/features/home/presentation/view/home_screen.dart';
import 'package:goanest/features/home/presentation/view/property_detail_screen.dart';
import 'package:goanest/features/home/presentation/view/recently_viewed_screen.dart';
import 'package:goanest/features/home/presentation/view/checkout_screen.dart';
import 'package:goanest/features/home/presentation/view/booking_confirmation_screen.dart';
import 'package:goanest/features/login/presentation/view/login_screen.dart';
import 'package:goanest/features/login/presentation/view/registration_screen.dart';
import 'package:goanest/features/splash/presentaion/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goanest/core/di/injector.dart';
import 'package:goanest/features/home/presentation/bloc/recently_viewed_bloc.dart';
import 'package:goanest/features/home/presentation/bloc/wishlist_bloc.dart';
import 'package:goanest/features/home/presentation/bloc/property_detail_bloc.dart';
import 'package:goanest/features/home/presentation/bloc/property_detail_event.dart';
import 'package:goanest/features/home/presentation/bloc/recently_viewed_event.dart';
import 'package:goanest/features/home/domain/usecase/get_recently_viewed.dart';
import 'package:goanest/features/home/domain/usecase/get_wishlists.dart';
import 'package:goanest/features/home/data/repository/home_repository_impl.dart';

import '../../core.dart';
import '../../utilities/extensions/extensions.dart';
import '../../utilities/global.dart';
import '../../widgets/app_page_not_found.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteName.splashView,
    navigatorKey: Global.navigatorKey,
    debugLogDiagnostics: true,
    requestFocus: false,
    routes: [
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
      GoRoute(
        name: 'search',
        path: RouteName.searchView,
        pageBuilder: (context, state) => appCustomTransitionPage(
          state: state,
          transitionBuilder: slideInOutTransition,
          child: const SearchWidget(),
        ),
      ),
      GoRoute(
        name: 'recently-viewed',
        path: RouteName.recentlyViewedView,
        pageBuilder: (context, state) => appCustomTransitionPage(
          state: state,
          transitionBuilder: slideInOutTransition,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    RecentlyViewedBloc(sl<GetRecentlyViewedUseCase>())
                      ..add(LoadRecentlyViewed()),
              ),
              BlocProvider(
                create: (_) => WishlistBloc(
                  sl<GetWishlistsUseCase>(),
                  sl<CreateWishlistUseCase>(),
                  sl<AddPropertyToWishlistUseCase>(),
                  sl<RemovePropertyFromWishlistUseCase>(),
                  sl<HomeRepositoryImpl>(),
                ),
              ),
            ],
            child: const RecentlyViewedScreen(),
          ),
        ),
      ),
      GoRoute(
        name: 'property',
        path: RouteName.propertyView,
        pageBuilder: (context, state) => appCustomTransitionPage(
          state: state,
          transitionBuilder: slideInOutTransition,
          child: BlocProvider(
            create: (_) => PropertyDetailBloc(sl<HomeRepositoryImpl>())
              ..add(
                LoadPropertyDetail(state.pathParameters['propertyId'] ?? ''),
              ),
            child: PropertyDetailScreen(
              propertyId: state.pathParameters['propertyId'] ?? '',
            ),
          ),
        ),
      ),
      GoRoute(
        name: 'checkout',
        path: RouteName.checkoutView,
        pageBuilder: (context, state) => appCustomTransitionPage(
          state: state,
          transitionBuilder: slideInOutTransition,
          child: const CheckoutScreen(),
        ),
      ),
      GoRoute(
        name: 'booking-confirmation',
        path: RouteName.bookingConfirmationView,
        pageBuilder: (context, state) => appCustomTransitionPage(
          state: state,
          transitionBuilder: slideInOutTransition,
          child: const BookingConfirmationScreen(),
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
